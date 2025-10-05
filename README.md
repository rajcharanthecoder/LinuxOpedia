# LinuxOpedia
An interactive Linux encyclopedia + RHCSA practice assistant for learners, sysadmins, and DevOps engineers.

# 🐧 LinuxOpedia — Your AI-powered Linux Command Explorer  

> Explore Linux commands interactively with AI assistance and RHCSA-style quizzes — all from your terminal.

---

## 🔑 Features  

- 🔍 **Explore Linux commands** with:  
  - Command **descriptions** (from man pages)  
  - **Practical examples** (from [tldr pages](https://tldr.sh/))  
  - **Snippets** directly from man pages  

- 🎯 **RHCSA Quiz Mode**  
  - AI-powered questions for RHCSA/DevOps practice  
  - Randomized command & concept questions  

- 🤖 **AI Integration**  
  - Uses OpenAI API for intelligent explanations and quiz generation  

- 💡 **Cross-distro support**  
  - Works on **RHEL, Fedora, Amazon Linux, Ubuntu, Debian**, and more  

---

## ⚙️ Installation  

### 1. Install dependencies  

**RHEL / Fedora / Amazon Linux**
```bash
sudo dnf install -y python3 python3-pip man-db
```

**Ubuntu / Debian**
```bash
sudo apt update
sudo apt install -y python3 python3-pip man-db
```

**Install Python libraries**
```bash
pip3 install rich tldr openai
```

**Update TLDR pages**
```bash
tldr --update
```

**Clone & install LinuxOpedia**
```bash




