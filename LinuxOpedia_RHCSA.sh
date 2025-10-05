#!/usr/bin/env python3
import os
import sys
import time
import shlex
import random
import subprocess
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.progress import Progress, SpinnerColumn, TextColumn

try:
    from openai import OpenAI
except ImportError:
    OpenAI = None

console = Console()

# ───────────────────────────────────────────────
#   Command Encyclopedia Functions
# ───────────────────────────────────────────────
def fetch_from_man(cmd):
    try:
        out = subprocess.run(["man", "-P", "col -b", cmd],
                             capture_output=True, text=True, timeout=5)
        text = out.stdout.splitlines()
        if not text:
            return None, None
        desc = ""
        for i, line in enumerate(text):
            if line.strip().startswith("NAME") and i+1 < len(text):
                desc = text[i+1].strip()
                break
        return desc, text[:40]
    except Exception:
        return None, None

def fetch_from_tldr(cmd):
    try:
        out = subprocess.run(["tldr", cmd], capture_output=True, text=True)
        if out.returncode == 0 and out.stdout.strip():
            return out.stdout.strip()
    except Exception:
        return None
    return None

def show_command(user_input):
    parts = shlex.split(user_input)
    cmd = parts[0]
    args = " ".join(parts[1:]) if len(parts) > 1 else ""

    desc, man_head = fetch_from_man(cmd)
    if not desc:
        console.print(f"[red]❌ No entry found for '{cmd}'[/red]")
        return

    title = f"[bold cyan]{cmd}[/bold cyan]"
    if args:
        title += f" [yellow]{args}[/yellow]"
    console.print(Panel(f"{title}\n{desc}", title="📖 Description"))

    examples = fetch_from_tldr(cmd)
    if examples:
        console.print(Panel(examples, title="🛠️ Examples (from TLDR)", border_style="green"))
    else:
        console.print(Panel("No TLDR examples found. Check man page.", border_style="yellow"))

    if man_head:
        snippet = "\n".join(man_head[:20])
        console.print(Panel(snippet, title="📜 From man page", border_style="blue"))


# ───────────────────────────────────────────────
#   Quiz Functions
# ───────────────────────────────────────────────
def fetch_ai_question():
    try:
        if OpenAI is None:
            return None
        key = os.getenv("OPENAI_API_KEY")
        if not key:
            return None
        client = OpenAI(api_key=key)
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system",
                 "content": "You are a Linux trainer. Generate realistic RHCSA/Linux admin practice scenarios."},
                {"role": "user",
                 "content": "Give me one Linux administration scenario only."}
            ]
        )
        return resp.choices[0].message.content.strip()
    except Exception:
        return None

def fetch_ai_solution(scenario):
    try:
        if OpenAI is None:
            return None
        key = os.getenv("OPENAI_API_KEY")
        if not key:
            return None
        client = OpenAI(api_key=key)
        resp = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system",
                 "content": "You are a Linux trainer. Provide step-by-step solutions with example commands."},
                {"role": "user",
                 "content": f"Scenario: {scenario}. Give correct solution with commands."}
            ]
        )
        return resp.choices[0].message.content.strip()
    except Exception as e:
        return f"[❌ Could not fetch AI solution: {e}]"

FALLBACK_QUESTIONS = [
    "Create a user 'rhcsa' with UID 1050 and set password expiry to 30 days.",
    "Archive /etc into /root/etc-backup.tar.gz",
    "Extend the logical volume 'datalv' by 200MB and resize the filesystem.",
    "Set SELinux to permissive mode permanently.",
    "Find all files under /var owned by root and larger than 50MB.",
    "Configure firewall to allow only SSH and HTTP traffic."
]

FALLBACK_SOLUTIONS = {
    FALLBACK_QUESTIONS[0]: "useradd -u 1050 rhcsa && chage -M 30 rhcsa",
    FALLBACK_QUESTIONS[1]: "tar -czvf /root/etc-backup.tar.gz /etc",
    FALLBACK_QUESTIONS[2]: "lvextend -L +200M /dev/datavg/datalv && resize2fs /dev/datavg/datalv",
    FALLBACK_QUESTIONS[3]: "Edit /etc/selinux/config → SELINUX=permissive; then reboot",
    FALLBACK_QUESTIONS[4]: "find /var -user root -size +50M",
    FALLBACK_QUESTIONS[5]: "firewall-cmd --permanent --add-service=ssh; "
                           "firewall-cmd --permanent --add-service=http; "
                           "firewall-cmd --reload"
}


def run_quiz():
    console.print(Panel("🎯 RHCSA Practice Mode", expand=True))
    scenario = fetch_ai_question()
    if not scenario:
        scenario = random.choice(FALLBACK_QUESTIONS)

    console.print(Panel(f"📌 Scenario:\n{scenario}", expand=True))
    answer = Prompt.ask("👉 Your answer")

    solution = fetch_ai_solution(scenario)
    if not solution:
        solution = FALLBACK_SOLUTIONS.get(scenario, "Solution not available.")

    console.print(Panel(f"✅ Example Solution:\n{solution}", expand=True))

    log_file = os.path.expanduser("~/linuxopedia_answers.log")
    with open(log_file, "a") as f:
        f.write(f"\n--- {time.strftime('%Y-%m-%d %H:%M:%S')} ---\n")
        f.write(f"Scenario: {scenario}\n")
        f.write(f"Your Answer: {answer}\n")
        f.write(f"Solution:   {solution}\n")

    console.print(f"[green]✅ Saved! Logged to {log_file}[/green]")


# ───────────────────────────────────────────────
#   Main Loop
# ───────────────────────────────────────────────
def main():
    console.print(Panel("👋 Welcome to [bold green]LinuxOpedia[/bold green]!\n"
                        "Type any Linux command for details, 'quiz' for RHCSA practice, or 'exit' to quit.",
                        border_style="cyan"))
    while True:
        cmd = console.input("\n[bold yellow]👉 Enter command / 'quiz' / 'exit': [/bold yellow]").strip()
        if cmd.lower() in ["exit", "quit"]:
            console.print("[bold red]Goodbye! 👋[/bold red]")
            break
        elif cmd.lower() == "quiz":
            run_quiz()
        else:
            with Progress(SpinnerColumn(), TextColumn("[progress.description]{task.description}"), transient=True) as progress:
                progress.add_task(description=f"Fetching details for '{cmd}'...", total=None)
                time.sleep(1)
            show_command(cmd)

if __name__ == "__main__":
    main()
