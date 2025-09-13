#!/bin/bash

echo "🔧 Fixing all hardcoded localhost URLs..."

# Function to replace getImageUrl in Vue files
fix_vue_file() {
    local file="$1"
    echo "📝 Fixing $file"
    
    # Replace hardcoded localhost URLs with flexible function
    sed -i 's|`http://localhost:9000/gallery-images/${[^}]*}`|getImageUrl(&)|g' "$file"
    sed -i 's|return `http://localhost:9000/gallery-images/${.*}`|return getImageUrl(imagePath)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${image\.storage_path}`|getImageUrl(image.storage_path)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${props\.image\.storage_path}`|getImageUrl(props.image.storage_path)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${props\.user\.avatar_path}`|getImageUrl(props.user.avatar_path)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${props\.user\.avatar}`|getImageUrl(props.user.avatar)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${img\.storage_path}`|getImageUrl(img.storage_path)|g' "$file"
    sed -i 's|`http://localhost:9000/gallery-images/${coverImage\.storage_path}`|getImageUrl(coverImage.storage_path)|g' "$file"
    
    # Add import at the top of script section if not already there
    if ! grep -q "import.*getImageUrl.*imageHelpers" "$file"; then
        sed -i '/import.*{.*from.*vue/a import { getImageUrl } from '\''@/utils/imageHelpers'\''' "$file"
    fi
}

# Update imageHelpers.js (already done but let's make sure)
echo "📝 Updating imageHelpers.js"
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

# Fix all the Vue files
fix_vue_file "resources/js/Pages/Profile/Show.vue"
fix_vue_file "resources/js/Pages/Dashboard.vue"
fix_vue_file "resources/js/Pages/Images/Edit.vue"
fix_vue_file "resources/js/Pages/Images/Upload.vue"
fix_vue_file "resources/js/Pages/Images/Index.vue"
fix_vue_file "resources/js/Pages/Images/Show.vue"
fix_vue_file "resources/js/Pages/Albums/Edit.vue"
fix_vue_file "resources/js/Pages/Albums/AddImages.vue"
fix_vue_file "resources/js/Pages/Albums/Index.vue"
fix_vue_file "resources/js/Pages/Albums/Show.vue"
fix_vue_file "resources/js/Pages/Admin/Users/Show.vue"
fix_vue_file "resources/js/Pages/Admin/Moderation/Index.vue"
fix_vue_file "resources/js/Pages/Welcome.vue"
fix_vue_file "resources/js/Pages/Collections/Create.vue"
fix_vue_file "resources/js/Pages/Collections/Index.vue"
fix_vue_file "resources/js/Pages/Collections/Show.vue"
fix_vue_file "resources/js/Components/Gallery/Lightbox.vue"
fix_vue_file "resources/js/Components/Gallery/ImageCard.vue"
fix_vue_file "resources/js/Components/CollectionModal.vue"
fix_vue_file "resources/js/Components/UserAvatar.vue"

echo "✅ All files updated!"
echo ""
echo "🧪 Test locally first:"
echo "Visit: http://localhost"
echo "Check that images still load"
echo ""
echo "🚀 If working, deploy:"
echo "git add ."
echo "git commit -m 'Fix image URLs for deployment'"
echo "git push origin production:main"
