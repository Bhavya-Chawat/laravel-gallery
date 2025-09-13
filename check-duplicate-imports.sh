#!/bin/bash

echo "🔍 CHECKING FOR DUPLICATE getImageUrl IMPORTS"
echo "============================================="

FILES_TO_CHECK=(
    "resources/js/Pages/Admin/Moderation/Index.vue"
    "resources/js/Pages/Admin/Users/Show.vue"
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
    "resources/js/Pages/Welcome.vue"
    "resources/js/Pages/Collections/Create.vue"
    "resources/js/Pages/Collections/Index.vue"
    "resources/js/Pages/Collections/Show.vue"
    "resources/js/Components/Gallery/Lightbox.vue"
    "resources/js/Components/Gallery/ImageCard.vue"
    "resources/js/Components/CollectionModal.vue"
    "resources/js/Components/UserAvatar.vue"
)

echo "Files with DUPLICATE getImageUrl imports:"
echo "----------------------------------------"

for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$file" ]; then
        IMPORT_COUNT=$(grep -c "import.*getImageUrl.*imageHelpers" "$file" 2>/dev/null || echo "0")
        if [ "$IMPORT_COUNT" -gt 1 ]; then
            echo "❌ $file ($IMPORT_COUNT duplicates)"
            echo "   Lines:"
            grep -n "import.*getImageUrl" "$file" | head -5
            echo ""
        elif [ "$IMPORT_COUNT" -eq 1 ]; then
            echo "✅ $file (OK)"
        else
            LOCAL_GETIMAGEURL=$(grep -c "const getImageUrl\|function getImageUrl" "$file" 2>/dev/null || echo "0")
            if [ "$LOCAL_GETIMAGEURL" -gt 0 ]; then
                echo "⚠️  $file (has local getImageUrl function)"
            else
                echo "➖ $file (no getImageUrl)"
            fi
        fi
    else
        echo "❓ $file (not found)"
    fi
done
