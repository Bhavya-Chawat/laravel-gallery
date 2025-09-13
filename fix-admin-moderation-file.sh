#!/bin/bash

echo "🎯 TARGETED FIX FOR Admin/Moderation/Index.vue"
echo "==============================================="

FILE="resources/js/Pages/Admin/Moderation/Index.vue"

if [ -f "$FILE" ]; then
    echo "📁 Found file: $FILE"
    
    # Create backup
    cp "$FILE" "${FILE}.backup-$(date +%s)"
    
    # Show current content around the problematic area
    echo "🔍 Current imports section:"
    head -20 "$FILE" | grep -n "import\|getImageUrl"
    
    # Method 1: Completely remove ALL getImageUrl related lines and rebuild
    echo "🧹 Removing ALL getImageUrl references..."
    
    # Remove all import lines with getImageUrl
    sed -i '/import.*getImageUrl/d' "$FILE"
    
    # Remove any const getImageUrl declarations
    sed -i '/const getImageUrl/,/^}/d' "$FILE"
    
    # Remove any function getImageUrl declarations  
    sed -i '/function getImageUrl/,/^}/d' "$FILE"
    
    # Remove any arrow function getImageUrl
    sed -i '/getImageUrl.*=.*=>/d' "$FILE"
    
    echo "✅ Removed all getImageUrl references"
    
    # Method 2: Add the import in the right place
    echo "📦 Adding clean import..."
    
    # Find where to add the import (after other imports but before layout import)
    if grep -q "import.*@heroicons" "$FILE"; then
        # Add after heroicons import
        sed -i '/import.*@heroicons/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$FILE"
    elif grep -q "import.*ziggy" "$FILE"; then
        # Add after ziggy import
        sed -i '/import.*ziggy/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$FILE"
    else
        # Add after script setup
        sed -i '/<script setup>/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$FILE"
    fi
    
    echo "✅ Added clean import"
    
    # Method 3: Replace any remaining hardcoded URLs
    sed -i 's|http://localhost:9000/gallery-images/\${image\.storage_path}|getImageUrl(image.storage_path)|g' "$FILE"
    sed -i 's|`http://localhost:9000/gallery-images/\${[^}]*}`|getImageUrl(imagePath)|g' "$FILE"
    
    echo "✅ Fixed hardcoded URLs"
    
    # Verify the fix
    echo "🔍 Verification:"
    echo "Import lines with getImageUrl:"
    grep -n "import.*getImageUrl" "$FILE" || echo "  (none found)"
    
    echo "Const declarations with getImageUrl:"
    grep -n "const getImageUrl" "$FILE" || echo "  (none found)"
    
    echo "Function declarations with getImageUrl:"
    grep -n "function getImageUrl" "$FILE" || echo "  (none found)"
    
    echo "Hardcoded localhost URLs:"
    grep -n "localhost:9000" "$FILE" || echo "  (none found)"
    
    echo ""
    echo "✅ Admin/Moderation/Index.vue fixed!"
    
else
    echo "❌ File not found: $FILE"
fi

echo ""
echo "🧪 Testing the fix..."
echo "Now try: npm run build"
