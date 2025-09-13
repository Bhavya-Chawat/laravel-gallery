#!/bin/bash

echo "🔧 COMPREHENSIVE FIX FOR ALL getImageUrl DUPLICATES"
echo "=================================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

FIXED_COUNT=0

# List of all files that might have duplicate getImageUrl
FILES_TO_FIX=(
    "resources/js/Pages/Profile/Show.vue"
    "resources/js/Pages/Dashboard.vue"
    "resources/js/Pages/Images/Edit.vue"
    "resources/js/Pages/Images/Upload.vue"
    "resources/js/Pages/Images/Index.vue"
    "resources/js/Pages/Images/Show.vue"
    "resources/js/Pages/Albums/Edit.vue"
    "resources/js/Pages/Albums/AddImages.vue"
    "resources/js/Pages/Albums/Index.vue"
    "resources/js/Pages/Albums/Show.vue"
    "resources/js/Pages/Admin/Users/Show.vue"
    "resources/js/Pages/Admin/Moderation/Index.vue"
    "resources/js/Pages/Welcome.vue"
    "resources/js/Pages/Collections/Create.vue"
    "resources/js/Pages/Collections/Index.vue"
    "resources/js/Pages/Collections/Show.vue"
    "resources/js/Components/Gallery/Lightbox.vue"
    "resources/js/Components/Gallery/ImageCard.vue"
    "resources/js/Components/CollectionModal.vue"
    "resources/js/Components/UserAvatar.vue"
)

echo -e "${YELLOW}Step 1: Removing ALL local getImageUrl functions...${NC}"

for file in "${FILES_TO_FIX[@]}"; do
    if [ -f "$file" ]; then
        echo "📝 Processing: $file"
        
        # Create backup
        cp "$file" "${file}.backup"
        
        # Remove ALL variations of local getImageUrl functions
        # Remove arrow function declarations
        sed -i '/const getImageUrl = /,/^}/d' "$file"
        sed -i '/const getImageUrl=/,/^}/d' "$file"
        
        # Remove regular function declarations  
        sed -i '/function getImageUrl/,/^}/d' "$file"
        
        # Remove inline arrow functions
        sed -i '/getImageUrl.*=.*=>/d' "$file"
        
        # Remove any hardcoded localhost URLs
        sed -i 's|`http://localhost:9000/gallery-images/\${[^}]*}`|getImageUrl(&)|g' "$file"
        sed -i 's|http://localhost:9000/gallery-images/|getImageUrl(|g' "$file"
        
        echo "✅ Cleaned: $file"
        ((FIXED_COUNT++))
    else
        echo "⚠️  File not found: $file"
    fi
done

echo -e "\n${YELLOW}Step 2: Adding proper imports to all files...${NC}"

for file in "${FILES_TO_FIX[@]}"; do
    if [ -f "$file" ]; then
        # Check if file uses getImageUrl anywhere
        if grep -q "getImageUrl" "$file"; then
            # Check if import already exists
            if ! grep -q "import.*getImageUrl.*imageHelpers" "$file"; then
                echo "📦 Adding import to: $file"
                
                # Find the right place to add import (after other imports)
                if grep -q "import.*from.*vue" "$file"; then
                    # Add after Vue import
                    sed -i '/import.*from.*vue/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$file"
                elif grep -q "<script" "$file"; then
                    # Add after script tag
                    sed -i '/<script/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$file"
                else
                    echo "⚠️  Could not find place to add import in: $file"
                fi
            else
                echo "✅ Import already exists in: $file"
            fi
        fi
    fi
done

echo -e "\n${YELLOW}Step 3: Ensuring imageHelpers.js is correct...${NC}"

# Make sure imageHelpers.js is properly set up
cat > resources/js/utils/imageHelpers.js << 'JSEOF'
export function getImageUrl(imagePath) {
  if (!imagePath) {
    return '/images/placeholder.jpg'
  }

  const baseUrl = window.location.origin
  const isLocal = baseUrl.includes('localhost') || baseUrl.includes('127.0.0.1')
  
  if (isLocal) {
    return `http://localhost:9000/gallery-images/${imagePath}`
  } else {
    return `${baseUrl}/storage/${imagePath}`
  }
}

export function getAvatarUrl(user) {
  if (!user?.avatar_path) {
    return null
  }
  return getImageUrl(user.avatar_path)
}

export function handleImageError(event, fallbackUrl = '/images/placeholder.jpg') {
  const img = event.target
  const currentSrc = img.src
  
  if (currentSrc.includes('localhost:9000')) {
    const imagePath = currentSrc.split('/').pop()
    img.src = `${window.location.origin}/storage/${imagePath}`
  } else {
    img.src = fallbackUrl
  }
}
JSEOF

echo "✅ Updated imageHelpers.js"

echo -e "\n${YELLOW}Step 4: Cleaning up any remaining issues...${NC}"

# Remove any duplicate import lines
for file in "${FILES_TO_FIX[@]}"; do
    if [ -f "$file" ]; then
        # Remove duplicate imports (keep only first)
        awk '!seen[$0] || !/import.*getImageUrl.*imageHelpers/' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
        
        # Fix any malformed template literals
        sed -i 's|getImageUrl(getImageUrl(|getImageUrl(|g' "$file"
        sed -i 's|getImageUrl(&)|getImageUrl(imagePath)|g' "$file"
    fi
done

echo -e "\n${YELLOW}Step 5: Verification...${NC}"

# Check for remaining issues
ISSUES_FOUND=0

echo "🔍 Checking for remaining duplicate getImageUrl declarations..."
for file in "${FILES_TO_FIX[@]}"; do
    if [ -f "$file" ]; then
        DUPLICATES=$(grep -c "const getImageUrl" "$file" 2>/dev/null || echo "0")
        FUNCTIONS=$(grep -c "function getImageUrl" "$file" 2>/dev/null || echo "0")
        
        if [ "$DUPLICATES" -gt 0 ] || [ "$FUNCTIONS" -gt 0 ]; then
            echo -e "${RED}❌ Still has duplicates: $file${NC}"
            ((ISSUES_FOUND++))
        fi
    fi
done

echo "🔍 Checking for hardcoded localhost URLs..."
for file in "${FILES_TO_FIX[@]}"; do
    if [ -f "$file" ]; then
        if grep -q "localhost:9000/gallery-images" "$file"; then
            echo -e "${RED}❌ Still has hardcoded URL: $file${NC}"
            ((ISSUES_FOUND++))
        fi
    fi
done

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}           CLEANUP COMPLETE!${NC}"
echo -e "${GREEN}===========================================${NC}"

echo -e "${GREEN}✅ Files processed: $FIXED_COUNT${NC}"
echo -e "${GREEN}✅ imageHelpers.js updated${NC}"

if [ "$ISSUES_FOUND" -eq 0 ]; then
    echo -e "${GREEN}✅ No duplicate getImageUrl functions found${NC}"
    echo -e "${GREEN}✅ No hardcoded URLs found${NC}"
    echo -e "\n${GREEN}🎉 ALL ISSUES FIXED! Ready for deployment!${NC}"
else
    echo -e "${RED}⚠️  $ISSUES_FOUND issues still remain${NC}"
    echo -e "${YELLOW}Check the files mentioned above manually${NC}"
fi

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Test locally: Visit http://localhost and check images load"
echo "2. If working: git add . && git commit -m 'Fix all getImageUrl duplicates'"
echo "3. Deploy: git push origin production:main"

echo -e "\n${YELLOW}🗑️  Backup files created with .backup extension${NC}"
echo "You can remove them with: find resources/js -name '*.backup' -delete"
