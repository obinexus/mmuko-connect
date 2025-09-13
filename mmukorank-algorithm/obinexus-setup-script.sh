#!/bin/bash

################################################################################
# OBINexus MmuoKò Connect Network Setup Script
# Integrates PageRank with git repositories and social media routing
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

# OBINexus configuration
OBINEXUS_BASE="${OBINEXUS_PATH:-/obinexus}"
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
    pip install -q networkx numpy requests GitPython 2>/dev/null || true
}

# Function to setup directory structure
setup_directory_structure() {
    echo -e "\n${BLUE}${RISING_TONE} Setting up OBINexus directory structure...${NC}"
    
    mkdir -p "$OBINEXUS_BASE"/{workspace,patents,clusters,manifests,cache}
    mkdir -p "$OBINEXUS_BASE"/workspace/{research,development,community}
    
    # Create cluster directories
    mkdir -p "$OBINEXUS_BASE"/clusters/{research,development,community,patents}
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
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
        "riftarch"
        "rifters_way"
        "gosilabs"
    )
    
    for repo in "${repos[@]}"; do
        local repo_path="$OBINEXUS_BASE/$repo"
        
        if [ -d "$repo_path/.git" ]; then
            echo -e "${CYAN}↻ Updating $repo...${NC}"
            (cd "$repo_path" && git pull --quiet 2>/dev/null || true)
        else
            echo -e "${YELLOW}⬇ Cloning $repo...${NC}"
            git clone --quiet "$GITHUB_ORG/$repo.git" "$repo_path" 2>/dev/null || \
            git clone --quiet "$OKPALAN_ORG/$repo.git" "$repo_path" 2>/dev/null || \
            echo -e "${RED}✗ Could not clone $repo${NC}"
        fi
    done
}

# Function to setup git hooks for PageRank integration
setup_git_hooks() {
    echo -e "\n${PURPLE}${HIGH_TONE} Setting up git hooks for PageRank integration...${NC}"
    
    local hook_script='#!/bin/bash
# OBINexus PageRank post-commit hook
python3 '$OBINEXUS_BASE'/obinexus_pagerank.py 2>/dev/null &
'
    
    for repo_dir in "$OBINEXUS_BASE"/*/.git; do
        if [ -d "$repo_dir" ]; then
            local hook_path="$repo_dir/hooks/post-commit"
            echo "$hook_script" > "$hook_path"
            chmod +x "$hook_path"
            echo -e "${GREEN}✓ Hook installed: $(dirname $repo_dir)${NC}"
        fi
    done
}

# Function to initialize PageRank system
initialize_pagerank() {
    echo -e "\n${BLUE}${RESONANCE} Initializing PageRank system...${NC}"
    
    # Copy PageRank script
    if [ -f "obinexus_pagerank.py" ]; then
        cp obinexus_pagerank.py "$OBINEXUS_BASE/"
        echo -e "${GREEN}✓ PageRank script deployed${NC}"
    fi
    
    # Run initial PageRank computation
    echo -e "${CYAN}Computing initial rankings...${NC}"
    cd "$OBINEXUS_BASE"
    python3 obinexus_pagerank.py
    
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

# Function to create service wrapper
create_service_wrapper() {
    echo -e "\n${PURPLE}${HIGH_TONE} Creating service wrapper...${NC}"
    
    cat > "$OBINEXUS_BASE/obinexus-service" <<'EOF'
#!/bin/bash
# OBINexus Service Wrapper

OBINEXUS_BASE="${OBINEXUS_PATH:-/obinexus}"
ACTION=$1

case "$ACTION" in
    start)
        echo "Starting OBINexus services..."
        python3 "$OBINEXUS_BASE/obinexus_pagerank.py" &
        echo $! > "$OBINEXUS_BASE/.pid"
        echo "✓ Services started"
        ;;
    stop)
        if [ -f "$OBINEXUS_BASE/.pid" ]; then
            kill $(cat "$OBINEXUS_BASE/.pid") 2>/dev/null
            rm "$OBINEXUS_BASE/.pid"
            echo "✓ Services stopped"
        fi
        ;;
    status)
        if [ -f "$OBINEXUS_BASE/.pid" ]; then
            if ps -p $(cat "$OBINEXUS_BASE/.pid") > /dev/null; then
                echo "✓ Services running"
            else
                echo "✗ Services not running"
            fi
        else
            echo "✗ Services not running"
        fi
        ;;
    rank)
        python3 "$OBINEXUS_BASE/obinexus_pagerank.py"
        ;;
    sync)
        for repo in "$OBINEXUS_BASE"/*/.git; do
            if [ -d "$repo" ]; then
                (cd "$(dirname $repo)" && git pull --quiet)
            fi
        done
        echo "✓ Repositories synced"
        ;;
    *)
        echo "Usage: obinexus-service {start|stop|status|rank|sync}"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$OBINEXUS_BASE/obinexus-service"
    
    # Create symlink
    if [ -w "/usr/local/bin" ]; then
        ln -sf "$OBINEXUS_BASE/obinexus-service" /usr/local/bin/obinexus 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✓ Service wrapper created${NC}"
}

# Function to display summary
display_summary() {
    echo -e "\n${PURPLE}${RESONANCE}${RESONANCE}${RESONANCE} Setup Complete ${RESONANCE}${RESONANCE}${RESONANCE}${NC}"
    echo "================================================================"
    
    if [ -f "$OBINEXUS_BASE/.obinexus-rank" ]; then
        echo -e "\n${CYAN}Top Ranked Nodes:${NC}"
        grep "rank =" "$OBINEXUS_BASE/.obinexus-rank" | head -5 | while read line; do
            echo "  $line"
        done
    fi
    
    echo -e "\n${GREEN}Available Commands:${NC}"
    echo "  obinexus start   - Start services"
    echo "  obinexus stop    - Stop services"
    echo "  obinexus status  - Check status"
    echo "  obinexus rank    - Compute PageRank"
    echo "  obinexus sync    - Sync repositories"
    
    echo -e "\n${YELLOW}Configuration Files:${NC}"
    echo "  $OBINEXUS_BASE/.obinexus-rank        - PageRank rankings"
    echo "  $OBINEXUS_BASE/mmuoko-connect.json   - MmuoKò configuration"
    
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
    create_service_wrapper
    display_summary
}

# Run main function
main "$@"