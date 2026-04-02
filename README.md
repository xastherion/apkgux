# APKGUX - AutoPkg Wrapper Script

A Bash wrapper for **AutoPkg** that simplifies and centralizes daily automation.

---

## 🎯 Advantages over Direct AutoPkg or AutoPkgr GUI

| Feature | AutoPkg CLI | AutoPkgr GUI | APKGUX |
|---------|------------|--------------|--------|
| **Configuration** | Terminal-based, complex | GUI, but scattered | Central, easily editable |
| **Automation** | Manual | Partial | Complete (logs, email, SMB) |
| **Email Notifications** | Not included | Included | ✓ Built-in |
| **SMB Mounting** | Manual | Not included | ✓ Automatic |
| **Logging** | Scattered | GUI-based | ✓ Centralized |
| **Configurable** | Via CLI flags | Hardcoded in GUI | ✓ Single config file |

---

## ❓ What is APKGUX?

An **automation wrapper** that simplifies AutoPkg:

- ✅ Update AutoPkg repositories
- ✅ Refresh trust information
- ✅ Execute recipe list
- ✅ Auto-mount SMB containers
- ✅ Centralized logging
- ✅ Email notifications

All with **one configuration file** and **minimal maintenance**.

---

## 🔧 How It Works

```
apkgux-conf.sh  →  Edit configuration  →  apkgux.cfg
                                               ↓
apkgux.sh  ←  Load configuration  ←  apkgux.cfg
     ↓
  - Check SMB container
  - Update repositories
  - Execute recipes
  - Send results via email
     ↓
  apkgux.log  (Results)
```

---

## ⚙️ Configuration

### 1. First Run
```bash
./apkgux-conf.sh
```

Answer 15 questions in 3 categories:
- **System Variables** (PATH, HOME)
- **AutoPkg Variables** (Cache, Repos, Recipes)
- **Email Settings** (SMTP, from/to, subject)

### 2. Edit File (optional)
Edit directly if needed:
```bash
nano apkgux.cfg
```

### 3. Run Script
```bash
./apkgux.sh          # Normal execution
./apkgux.sh debug    # Output to screen
```

---

## 📁 Files

| File | Purpose |
|------|---------|
| `apkgux.sh` | Main script - runs AutoPkg |
| `apkgux-conf.sh` | Configuration wizard |
| `apkgux.cfg` | Configuration file (central) |
| `apkgux.log` | Results / Log file |

---

## 📝 Example apkgux.cfg

```bash
# ================================================= #
# SYSTEM VARIABLES
# ================================================= #
export PATH="/usr/local/bin:/usr/bin:..."
export HOME="/Users/username"

# ================================================= #
# AUTOPKG VARIABLES
# ================================================= #
export REPOS="/path/to/RecipeRepos/*"
export LISTA="/path/to/RecipeList.txt"
export LOGFI="/path/to/apkgux.log"

# ================================================= #
# EMAIL SETTINGS
# ================================================= #
export SMTP_SRVR="smtp.example.com"
export TO_EMAIL="admin@example.com"
```

---

## 🚀 Tips

- **Cron Job**: Add to `crontab` for daily execution
- **Backup**: `apkgux.cfg.bak` is created automatically
- **Logs**: Check `apkgux.log` for results
- **Ctrl+C**: Cancels configuration without saving
- **CRON IMPORTANT**: cron muss have Full Disk Access

---

## 📋 Minimum Requirements

- bash or zsh
- AutoPkg installed
- curl (for email)
- Access to SMB shares (optional)

---

**APKGUX** = AutoPkg + simple configuration = Fewer clicks, more automation.
