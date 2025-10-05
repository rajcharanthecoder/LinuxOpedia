***Only for Linux / RCHSA / RHCE Enthusiasts***

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

**PATH**
```bash
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc
```

**Update TLDR pages**
```bash
tldr --update
```

**Clone & install LinuxOpedia**
```bash
git clone https://github.com/rajcharanthecoder/LinuxOpedia.git
cd linuxopedia
sudo cp linuxopedia /usr/local/bin/linuxopedia
sudo chmod +x /usr/local/bin/linuxopedia
```

**(Optional) Setup OpenAI key for AI Quiz Mode**
```bash
export OPENAI_API_KEY="your_api_key_here
```

**🚀 Usage**
***Start the tool:***
```bash
linuxopedia
```

**You’ll see:**
```bash
👋 Welcome to LinuxOpedia!
Type any Linux command for details, 'quiz' for RHCSA practice, or 'exit' to quit.
```

***🔍 Command Mode***
```bash
👉 Enter command / 'quiz' / 'exit': ls
```

**Output:**
```bash
📘 Description: List directory contents.
💡 Example: ls -l  →  Displays files in long format.
📖 Man Snippet: ls - list directory contents
```

***Example***

![LinuxOpedia Demo](https://github.com/user-attachments/assets/15c46798-8682-4c31-bd1b-6d30558dd080)

See If you notice correctly commands get sorted as above , you may need to wait for rchsa practise quaestions to pop up. Answers do pop up also.

<img width="1918" height="1140" alt="image" src="https://github.com/user-attachments/assets/77ef8302-5213-4e6c-8644-53f1c1ecfe80" />

***To revist the questions , do kindly visit /root/linuxopedia_answers.log on server"***







