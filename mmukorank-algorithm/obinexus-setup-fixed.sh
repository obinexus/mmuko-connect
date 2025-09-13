#!/bin/bash

################################################################################
# OBINexus MmuoKò Connect Network Setup Script - LOCAL VERSION
# Works with user home directory instead of root /obinexus
# 
# Schema: setup.mmuoko-connect.obinexus.network.2025
################################################################################

set -e

# Color codes for tonal output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# OBINexus configuration - Use local directory
OBINEXUS_BASE="${OBINEXUS_PATH:-$HOME/obinexus}"
WORKSPACE_DIR="$OBINEXUS_BASE/workspace"
MMUOKO_DIR="$WORKSPACE_DIR/mmuoko-connect"
ALGORITHM_DIR="$MMUOKO_DIR/mmukorank-algorithm"
GITHUB_ORG="github.com/obinexus"
OKPALAN_ORG="github.com/okpalandev"

# Tonal layer indicators (Nsibidi protocol)
HIGH_TONE="◈"
LOW_TONE="◉"
RISING_TONE="●"
FALLING_TONE="◐"
MID_TONE="◊"
HARMONIC="◈◉"
RESONANCE="⟠"

echo -e "${PURPLE}${HIGH_TONE}${RESONANCE}${HIGH_TONE} OBINexus MmuoKò Connect Network Setup ${NC}"
echo "================================================================"
echo -e "${CYAN}Base Directory: $OBINEXUS_BASE${NC}"

# Function to check dependencies
check_dependencies() {
    echo -e "\n${CYAN}${MID_TONE} Checking dependencies...${NC}"
    
    local deps=("git" "python3" "pip" "curl")
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${RED}✗ Missing: $dep${NC}"
            exit 1
        else
            echo -e "${GREEN}✓ Found: $dep${NC}"
        fi
    done
    
    # Check Python packages
    echo -e "\n${CYAN}${MID_TONE} Installing Python dependencies...${NC}"
    pip install --user -q networkx numpy requests GitPython 2>/dev/null || {
        echo -e "${YELLOW}⚠ Some Python packages may need manual installation${NC}"
    }
}

# Function to setup directory structure
setup_directory_structure() {
    echo -e "\n${BLUE}${RISING_TONE} Setting up OBINexus directory structure...${NC}"
    
    # Create directories in user's home
    mkdir -p "$OBINEXUS_BASE"/{workspace,patents,clusters,manifests,cache,autopost}
    mkdir -p "$WORKSPACE_DIR"/{research,development,community}
    mkdir -p "$MMUOKO_DIR"/{posts,analytics,schedules}
    mkdir -p "$ALGORITHM_DIR"/{configs,logs,data}
    
    # Create cluster directories
    mkdir -p "$OBINEXUS_BASE"/clusters/{research,development,community,patents}
    
    # Create autopost directories
    mkdir -p "$OBINEXUS_BASE"/autopost/{queue,sent,templates,logs}
    
    echo -e "${GREEN}✓ Directory structure created at $OBINEXUS_BASE${NC}"
}

# Function to clone/update repositories
sync_repositories() {
    echo -e "\n${YELLOW}${HARMONIC} Syncing OBINexus repositories...${NC}"
    
    local repos=(
        "mmuoko-connect"
        "mmuoko-studios"
        "phantomid"
        "patents"
        "polycall"
        "rift"
        "riftlang"
    )
    
    for repo in "${repos[@]}"; do
        local repo_path="$WORKSPACE_DIR/$repo"
        
        if [ -d "$repo_path/.git" ]; then
            echo -e "${CYAN}↻ Updating $repo...${NC}"
            (cd "$repo_path" && git pull --quiet 2>/dev/null || true)
        else
            echo -e "${YELLOW}⬇ Cloning $repo...${NC}"
            git clone --quiet "$GITHUB_ORG/$repo.git" "$repo_path" 2>/dev/null || \
            git clone --quiet "$OKPALAN_ORG/$repo.git" "$repo_path" 2>/dev/null || \
            echo -e "${YELLOW}⚠ Could not clone $repo (may not exist yet)${NC}"
        fi
    done
}

# Function to setup git hooks for PageRank integration
setup_git_hooks() {
    echo -e "\n${PURPLE}${HIGH_TONE} Setting up git hooks for PageRank integration...${NC}"
    
    local hook_script='#!/bin/bash
# OBINexus PageRank post-commit hook
OBINEXUS_BASE="'$OBINEXUS_BASE'"
python3 "$OBINEXUS_BASE/workspace/mmuoko-connect/mmukorank-algorithm/obinexus-pagerank.py" 2>/dev/null &
'
    
    for repo_dir in "$WORKSPACE_DIR"/*/.git; do
        if [ -d "$repo_dir" ]; then
            local hook_path="$repo_dir/hooks/post-commit"
            echo "$hook_script" > "$hook_path"
            chmod +x "$hook_path"
            echo -e "${GREEN}✓ Hook installed: $(basename $(dirname $repo_dir))${NC}"
        fi
    done
}

# Function to initialize PageRank system
initialize_pagerank() {
    echo -e "\n${BLUE}${RESONANCE} Initializing PageRank system...${NC}"
    
    # Copy PageRank scripts to base directory
    if [ -f "$ALGORITHM_DIR/obinexus-pagerank.py" ]; then
        cp "$ALGORITHM_DIR/obinexus-pagerank.py" "$OBINEXUS_BASE/"
        echo -e "${GREEN}✓ PageRank script deployed${NC}"
    fi
    
    if [ -f "$ALGORITHM_DIR/mmuoko-connect-router.js" ]; then
        cp "$ALGORITHM_DIR/mmuoko-connect-router.js" "$OBINEXUS_BASE/"
        echo -e "${GREEN}✓ Router script deployed${NC}"
    fi
    
    # Run initial PageRank computation
    echo -e "${CYAN}Computing initial rankings...${NC}"
    cd "$OBINEXUS_BASE"
    OBINEXUS_PATH="$OBINEXUS_BASE" python3 obinexus-pagerank.py 2>/dev/null || {
        echo -e "${YELLOW}⚠ PageRank computation needs manual run${NC}"
    }
    
    if [ -f ".obinexus-rank" ]; then
        echo -e "${GREEN}✓ Initial rankings computed${NC}"
    fi
}

# Function to setup MmuoKò Connect integration
setup_mmuoko_connect() {
    echo -e "\n${YELLOW}${HARMONIC} Setting up MmuoKò Connect integration...${NC}"
    
    # Create MmuoKò Connect configuration
    cat > "$OBINEXUS_BASE/mmuoko-connect.json" <<EOF
{
    "network": "obinexus",
    "base_path": "$OBINEXUS_BASE",
    "schema": "mmuoko-connect.social.obinexus.2025",
    "clusters": {
        "research": {
            "uri": "$GITHUB_ORG/research",
            "layer": 7,
            "mode": "Uche"
        },
        "development": {
            "uri": "$GITHUB_ORG/development",
            "layer": 4,
            "mode": "Eze"
        },
        "community": {
            "uri": "$GITHUB_ORG/mmuoko-connect",
            "layer": 3,
            "mode": "Obi"
        },
        "patents": {
            "uri": "$GITHUB_ORG/patents",
            "layer": 5,
            "mode": "Uche"
        }
    },
    "tonal_signatures": {
        "high": "$HIGH_TONE",
        "low": "$LOW_TONE",
        "harmonic": "$HARMONIC",
        "resonance": "$RESONANCE"
    },
    "platforms": ["github", "x", "tiktok", "native"],
    "phantomid_required": true,
    "coherence_threshold": 0.954
}
EOF
    
    echo -e "${GREEN}✓ MmuoKò Connect configuration created${NC}"
}

# Function to setup auto-posting system
setup_autopost() {
    echo -e "\n${PURPLE}${RESONANCE} Setting up auto-posting system...${NC}"
    
    # Create auto-post scheduler script
    cat > "$OBINEXUS_BASE/autopost/scheduler.py" <<'EOF'
#!/usr/bin/env python3
"""
OBINexus Auto-Post Scheduler
Automated content distribution with PageRank optimization
"""

import json
import time
import os
import subprocess
from datetime import datetime, timedelta
from pathlib import Path

class AutoPostScheduler:
    def __init__(self):
        self.base_path = Path(os.environ.get('OBINEXUS_PATH', os.path.expanduser('~/obinexus')))
        self.queue_dir = self.base_path / 'autopost' / 'queue'
        self.sent_dir = self.base_path / 'autopost' / 'sent'
        self.templates_dir = self.base_path / 'autopost' / 'templates'
        self.config = self.load_config()
        
    def load_config(self):
        config_path = self.base_path / 'mmuoko-connect.json'
        if config_path.exists():
            with open(config_path) as f:
                return json.load(f)
        return {}
    
    def generate_content(self, template_name='default'):
        """Generate content based on template and current rankings"""
        # Load PageRank data
        rank_file = self.base_path / '.obinexus-rank'
        if not rank_file.exists():
            subprocess.run(['python3', str(self.base_path / 'obinexus-pagerank.py')])
        
        # Generate content based on top-ranked nodes
        timestamp = datetime.now().isoformat()
        content = {
            'timestamp': timestamp,
            'template': template_name,
            'message': f"🔷 OBINexus Update {timestamp[:10]}",
            'platforms': ['x', 'github'],
            'tone': 'harmonic',
            'cluster': 'community'
        }
        
        return content
    
    def schedule_post(self, content, delay_minutes=0):
        """Schedule a post for distribution"""
        scheduled_time = datetime.now() + timedelta(minutes=delay_minutes)
        
        post_data = {
            'content': content,
            'scheduled': scheduled_time.isoformat(),
            'status': 'queued'
        }
        
        # Save to queue
        queue_file = self.queue_dir / f"post_{int(time.time())}.json"
        with open(queue_file, 'w') as f:
            json.dump(post_data, f, indent=2)
        
        return queue_file
    
    def process_queue(self):
        """Process queued posts"""
        for queue_file in self.queue_dir.glob('*.json'):
            with open(queue_file) as f:
                post = json.load(f)
            
            scheduled_time = datetime.fromisoformat(post['scheduled'])
            
            if datetime.now() >= scheduled_time:
                # Post using router
                result = subprocess.run([
                    'node',
                    str(self.base_path / 'mmuoko-connect-router.js'),
                    'route',
                    post['content']['message']
                ], capture_output=True, text=True)
                
                # Move to sent
                post['sent'] = datetime.now().isoformat()
                post['result'] = result.stdout
                
                sent_file = self.sent_dir / queue_file.name
                with open(sent_file, 'w') as f:
                    json.dump(post, f, indent=2)
                
                queue_file.unlink()
                print(f"✓ Posted: {post['content']['message'][:50]}...")
    
    def run_daemon(self, interval_seconds=60):
        """Run as daemon, checking queue periodically"""
        print("🔷 OBINexus Auto-Post Daemon Started")
        print(f"Checking every {interval_seconds} seconds...")
        
        while True:
            try:
                self.process_queue()
            except Exception as e:
                print(f"Error: {e}")
            
            time.sleep(interval_seconds)

if __name__ == "__main__":
    import sys
    
    scheduler = AutoPostScheduler()
    
    if len(sys.argv) > 1:
        if sys.argv[1] == 'daemon':
            scheduler.run_daemon()
        elif sys.argv[1] == 'post':
            content = scheduler.generate_content()
            queue_file = scheduler.schedule_post(content)
            print(f"Scheduled: {queue_file}")
        elif sys.argv[1] == 'process':
            scheduler.process_queue()
    else:
        print("Usage: scheduler.py [daemon|post|process]")
EOF
    
    chmod +x "$OBINEXUS_BASE/autopost/scheduler.py"
    
    # Create systemd service file (optional)
    cat > "$OBINEXUS_BASE/autopost/obinexus-autopost.service" <<EOF
[Unit]
Description=OBINexus Auto-Post Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$OBINEXUS_BASE
Environment="OBINEXUS_PATH=$OBINEXUS_BASE"
ExecStart=/usr/bin/python3 $OBINEXUS_BASE/autopost/scheduler.py daemon
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    
    echo -e "${GREEN}✓ Auto-posting system configured${NC}"
    echo -e "${CYAN}To enable auto-posting as a service:${NC}"
    echo -e "  sudo cp $OBINEXUS_BASE/autopost/obinexus-autopost.service /etc/systemd/system/"
    echo -e "  sudo systemctl enable obinexus-autopost"
    echo -e "  sudo systemctl start obinexus-autopost"
}

# Function to create service wrapper
create_service_wrapper() {
    echo -e "\n${PURPLE}${HIGH_TONE} Creating service wrapper...${NC}"
    
    cat > "$OBINEXUS_BASE/obinexus" <<EOF
#!/bin/bash
# OBINexus Service Wrapper

export OBINEXUS_PATH="$OBINEXUS_BASE"
ACTION=\$1

case "\$ACTION" in
    start)
        echo "Starting OBINexus services..."
        python3 "\$OBINEXUS_PATH/autopost/scheduler.py" daemon &
        echo \$! > "\$OBINEXUS_PATH/.pid"
        echo "✓ Services started"
        ;;
    stop)
        if [ -f "\$OBINEXUS_PATH/.pid" ]; then
            kill \$(cat "\$OBINEXUS_PATH/.pid") 2>/dev/null
            rm "\$OBINEXUS_PATH/.pid"
            echo "✓ Services stopped"
        fi
        ;;
    status)
        if [ -f "\$OBINEXUS_PATH/.pid" ]; then
            if ps -p \$(cat "\$OBINEXUS_PATH/.pid") > /dev/null; then
                echo "✓ Services running"
            else
                echo "✗ Services not running"
            fi
        else
            echo "✗ Services not running"
        fi
        ;;
    rank)
        python3 "\$OBINEXUS_PATH/obinexus-pagerank.py"
        ;;
    post)
        python3 "\$OBINEXUS_PATH/autopost/scheduler.py" post
        ;;
    sync)
        for repo in "\$OBINEXUS_PATH"/workspace/*/.git; do
            if [ -d "\$repo" ]; then
                (cd "\$(dirname \$repo)" && git pull --quiet)
            fi
        done
        echo "✓ Repositories synced"
        ;;
    *)
        echo "Usage: obinexus {start|stop|status|rank|post|sync}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$OBINEXUS_BASE/obinexus"
    
    # Add to PATH
    echo -e "${CYAN}Adding obinexus to PATH...${NC}"
    if ! grep -q "OBINEXUS_PATH" ~/.bashrc; then
        echo "export OBINEXUS_PATH=\"$OBINEXUS_BASE\"" >> ~/.bashrc
        echo "export PATH=\"\$PATH:$OBINEXUS_BASE\"" >> ~/.bashrc
    fi
    
    echo -e "${GREEN}✓ Service wrapper created${NC}"
    echo -e "${YELLOW}Run 'source ~/.bashrc' to update PATH${NC}"
}

# Function to display summary
display_summary() {
    echo -e "\n${PURPLE}${RESONANCE}${RESONANCE}${RESONANCE} Setup Complete ${RESONANCE}${RESONANCE}${RESONANCE}${NC}"
    echo "================================================================"
    
    echo -e "\n${GREEN}Installation Directory:${NC}"
    echo "  $OBINEXUS_BASE"
    
    if [ -f "$OBINEXUS_BASE/.obinexus-rank" ]; then
        echo -e "\n${CYAN}Top Ranked Nodes:${NC}"
        grep "rank =" "$OBINEXUS_BASE/.obinexus-rank" 2>/dev/null | head -5 | while read line; do
            echo "  $line"
        done
    fi
    
    echo -e "\n${GREEN}Available Commands:${NC}"
    echo "  obinexus start   - Start auto-posting daemon"
    echo "  obinexus stop    - Stop services"
    echo "  obinexus status  - Check status"
    echo "  obinexus rank    - Compute PageRank"
    echo "  obinexus post    - Schedule a post"
    echo "  obinexus sync    - Sync repositories"
    
    echo -e "\n${YELLOW}Configuration Files:${NC}"
    echo "  $OBINEXUS_BASE/.obinexus-rank        - PageRank rankings"
    echo "  $OBINEXUS_BASE/mmuoko-connect.json   - MmuoKò configuration"
    echo "  $OBINEXUS_BASE/autopost/             - Auto-posting system"
    
    echo -e "\n${CYAN}Quick Start:${NC}"
    echo "  1. source ~/.bashrc"
    echo "  2. obinexus rank     # Compute initial rankings"
    echo "  3. obinexus post     # Schedule a test post"
    echo "  4. obinexus start    # Start auto-posting daemon"
    
    echo -e "\n${PURPLE}${HIGH_TONE}${RESONANCE}${HIGH_TONE} Anchor Your Spirit - and I did just THAT! ${NC}"
}

# Main execution
main() {
    check_dependencies
    setup_directory_structure
    sync_repositories
    setup_git_hooks
    initialize_pagerank
    setup_mmuoko_connect
    setup_autopost
    create_service_wrapper
    display_summary
}

# Run main function
main "$@"