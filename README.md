
***

# Laravel Gallery

<div align="center">

**Laravel Gallery - Professional Image Management Platform**

[![Laravel](https://img.shields.io/badge/Laravel-10-FF2D20?logo=laravel)](https://laravel.com)
[![Vue.js](https://img.shields.io/badge/Vue.js-3-4FC08D?logo=vue.js)](https://vuejs.org)
[![PHP](https://img.shields.io/badge/PHP-8.1+-777BB4?logo=php)](https://php.net)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14-336791?logo=postgresql)](https://postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

</div>

## 🚀 **Quick Start for Local Testing**

> **🔄 For Local Development:** Switch to the `local` branch for the complete development setup with all dependencies and configurations optimized for local testing.

> **Transform your visual asset management with AI intelligence, professional-grade security, and intuitive design.** Built for photographers, agencies, content creators, and enterprises requiring sophisticated image management workflows.

***

## ✨ **Core Features**

### 🖼️ **Advanced Gallery Management**
- **Multi-format support** (WebP, AVIF, JPEG, PNG) with automatic optimization[1]
- **Intelligent EXIF handling** - preserves metadata while protecting privacy
- **Drag-and-drop uploads** with batch processing and mobile optimization
- **Dynamic thumbnail generation** with configurable quality settings
- **CDN-ready storage** via MinIO/S3 compatibility

### 🔍 **Smart Organization & Discovery**
- **AI-powered tagging** and automatic categorization
- **Advanced search** by keywords, tags, colors, EXIF data, and users
- **Dynamic albums & collections** with privacy controls
- **Color palette extraction** and visual similarity matching
- **Real-time view tracking** and engagement analytics

### 👥 **Enterprise User Management**
- **Role-based access control** (Admin, Editor, Visitor)
- **Granular permissions** with Laravel Policy system
- **Storage quotas** and usage monitoring per user
- **Comprehensive audit logging** for all user actions
- **OAuth integration** with secure session management

### 🛡️ **Security & Privacy First**
- **Enterprise-grade authentication** via Laravel Sanctum
- **GPS metadata removal** for privacy protection
- **Virus scanning** on uploads with validation
- **Encrypted storage** with presigned URLs for secure access
- **Content moderation** with approval workflows

***

## 🚀 **AI-Powered Features**

### **ClipDrop Integration**
- **Text-to-image generation** directly in the platform
- **Image enhancement** and background removal
- **Batch AI processing** for multiple assets
- **Creative studio tools** for professional workflows

***

## 🛠️ **Modern Tech Stack**

<table>
<tr>
<td valign="top" width="33%">

**Backend Foundation**
- **Laravel 10** (PHP 8.1+)
- **PostgreSQL** with optimized queries
- **Redis** for caching & queues
- **MinIO/S3** storage abstraction
- **Docker** containerization

</td>
<td valign="top" width="33%">

**Frontend Excellence**
- **Vue.js 3** with Composition API
- **Inertia.js** for seamless SPA experience
- **Vite** for lightning-fast builds
- **Tailwind CSS** with dark mode
- **TypeScript** support

</td>
<td valign="top" width="33%">

**Developer Experience**
- **Laravel Sail** for easy development
- **Hot Module Replacement**
- **ESLint & Prettier** code formatting
- **Comprehensive testing** with PHPUnit
- **API documentation** with Swagger

</td>
</tr>
</table>

***

## 🏃‍♂️ **Quick Start**

### **Prerequisites**
- Docker & Docker Compose
- Node.js 18+
- Git

### **Installation**

```bash
# Clone the repository
git clone <your-repo-url> laravel-gallery
cd laravel-gallery

# Install PHP dependencies via Docker
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/var/www/html \
    -w /var/www/html \
    laravelsail/php83-composer:latest \
    composer install

# Start the Docker environment
./vendor/bin/sail up -d

# Environment setup
cp .env.example .env
./vendor/bin/sail artisan key:generate

# Database setup
./vendor/bin/sail artisan migrate --seed

# Install and build frontend assets
./vendor/bin/sail npm install --legacy-peer-deps
./vendor/bin/sail npm run build
```

### **Access the Application**

- **Application**: [http://localhost](http://localhost)
- **MinIO Console**: [http://localhost:8900](http://localhost:8900)
- **Mail Testing**: [http://localhost:8025](http://localhost:8025)
- **Database**: `localhost:5432`

### **Default Admin Credentials**
```
Email: admin@gallery.local
Password: admin123
```

***

## 📁 **Project Architecture**

### **Core Structure**[1]
```
laravel-gallery/
├── app/
│   ├── Http/Controllers/         # MVC Controllers
│   │   ├── Admin/               # Admin panel controllers
│   │   ├── Api/                 # API endpoints
│   │   └── Auth/                # Authentication logic
│   ├── Models/                  # Eloquent models
│   ├── Policies/                # Authorization policies
│   └── Jobs/                    # Queue jobs
├── resources/
│   ├── js/
│   │   ├── Components/          # Vue.js components
│   │   ├── Pages/               # Inertia.js pages
│   │   └── Layouts/             # Application layouts
│   └── css/                     # Styling assets
├── database/
│   ├── migrations/              # Database migrations
│   └── seeders/                 # Sample data
└── docker-compose.yml           # Development environment
```

### **Key Models & Relationships**[2]
- **User** → Roles, Images, Albums, Collections
- **Image** → Tags, Comments, Likes, ViewCounts, Versions
- **Album** → Images, User permissions
- **Collection** → Curated image groupings
- **AuditLog** → Complete action tracking

***

## 🎨 **UI/UX Design**

### **Glassmorphism Interface**
- **Frosted glass aesthetics** with depth and elegance
- **Dark/light mode** with system preference detection
- **Responsive design** optimized for all devices
- **WCAG 2.1 accessibility** compliance

### **Component Library**
- **Reusable Vue components** for consistency
- **Gallery grids** with masonry layouts
- **Interactive lightboxes** for image viewing
- **Drag-and-drop interfaces** for uploads

***

## 🔧 **Configuration**

### **Environment Variables**

<details>
<summary><strong>Core Application Settings</strong></summary>

```env
APP_NAME="Laravel Gallery"
APP_ENV=local
APP_URL=http://localhost
APP_DEBUG=true
```
</details>

<details>
<summary><strong>Database Configuration</strong></summary>

```env
DB_CONNECTION=pgsql
DB_HOST=pgsql
DB_PORT=5432
DB_DATABASE=image_gallery
DB_USERNAME=sail
DB_PASSWORD=password
```
</details>

<details>
<summary><strong>Storage & MinIO Setup</strong></summary>

```env
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=sail
AWS_SECRET_ACCESS_KEY=password
AWS_BUCKET=gallery-images
AWS_ENDPOINT=http://minio:9000
AWS_URL=http://localhost:9000
```
</details>

<details>
<summary><strong>Gallery-Specific Settings</strong></summary>

```env
GALLERY_MAX_UPLOAD_SIZE=52428800
GALLERY_ALLOWED_MIMES=image/jpeg,image/png,image/webp,image/avif
GALLERY_QUALITY_JPEG=85
GALLERY_QUALITY_WEBP=80
```
</details>

***

## 🌟 **User Roles & Capabilities**

| Role | Upload | Manage Albums | AI Features | User Management | System Settings |
|------|--------|---------------|-------------|-----------------|-----------------|
| **Admin** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Editor** | ✅ | ✅ | ✅ | ❌ | ❌ |
| **Visitor** | ❌ | Personal Only | ❌ | ❌ | ❌ |

***

## 🚀 **Performance & Scalability**

### **Optimization Features**
- **Redis caching** for database queries and sessions
- **Queue system** for background processing (image optimization, AI tasks)
- **CDN integration** for global asset delivery
- **Database indexing** for fast search operations
- **Lazy loading** for improved page performance

### **Monitoring & Analytics**
- **View tracking** and engagement metrics
- **Storage usage** monitoring per user
- **Performance insights** via Laravel Telescope (optional)
- **Error tracking** with comprehensive logging

***

## 📊 **Demo & Screenshots**

### **Recommended Demo Flow**

1. **Homepage** - Featured galleries and site overview
2. **Public Gallery** - Browse images with filters
3. **User Dashboard** - Personal statistics and quick actions
4. **Upload Interface** - Drag-and-drop with progress tracking
5. **Album Management** - Create and organize collections
6. **Admin Panel** - User management and system overview
7. **Mobile Responsive** - Touch-optimized interface

**View comprehensive screenshots and demo video:**
[📁 Demo Media Collection](https://drive.google.com/drive/folders/1YoOjy_cjXi2oLaySYfcoNGEIcBhEppPX)

***

## 🛡️ **Security Features**[1]

### **Authentication & Authorization**
- **Laravel Sanctum** for API authentication
- **Role-based permissions** with Policy classes
- **Session management** with Redis storage
- **Password hashing** with configurable rounds

### **Data Protection**
- **EXIF privacy** with GPS removal
- **Upload validation** and virus scanning
- **Secure file storage** with presigned URLs
- **SQL injection protection** via Eloquent ORM

### **Audit & Compliance**
- **Complete action logging** in AuditLog model
- **User activity tracking** with IP and timestamp
- **Content moderation** workflows
- **GDPR compliance** features

***

## 🎯 **Perfect For**

- **🎨 Creative Agencies** - Client asset management with collaboration
- **📸 Photographers** - Portfolio management with AI organization
- **🎬 Content Creators** - Media library with smart categorization
- **🏢 Enterprises** - Secure digital asset management at scale
- **👥 Teams** - Collaborative workspace with role-based access

***

## 📚 **API Documentation**

### **RESTful Endpoints**
```
GET    /api/images              # List images with filters
POST   /api/images              # Upload new image
GET    /api/images/{id}         # Get image details
PUT    /api/images/{id}         # Update image metadata
DELETE /api/images/{id}         # Delete image

GET    /api/albums              # List albums
POST   /api/albums              # Create album
GET    /api/albums/{id}         # Get album with images
```

### **Authentication**
All API endpoints require Bearer token authentication via Laravel Sanctum.[1]

***

## 🧪 **Testing**

```bash
# Run PHP tests
./vendor/bin/sail test

# Run JavaScript tests  
./vendor/bin/sail npm run test

# Feature tests
./vendor/bin/sail test --filter=Feature

# Code coverage
./vendor/bin/sail test --coverage
```

***

## 🚀 **Deployment**

### **Production Setup**

<details>
<summary><strong>Railway Deployment</strong></summary>

1. Connect your GitHub repository to Railway
2. Add PostgreSQL service to your project
3. Configure environment variables:
   ```env
   APP_ENV=production
   APP_DEBUG=false
   APP_KEY=base64:your-generated-key
   DATABASE_URL=postgresql://user:password@host:port/dbname
   ```
4. Deploy automatically on git push
</details>

<details>
<summary><strong>Docker Production</strong></summary>

```bash
# Build production image
docker build -t laravel-gallery .

# Run with production environment
docker-compose -f docker-compose.prod.yml up -d
```
</details>

***

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

***

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

***

## 🙋‍♂️ **Support & Community**

- **📧 Email**: support@gallery.example.com
- **💬 Discord**: [Join our community](https://discord.gg/laravel-gallery)
- **🐛 Issues**: [GitHub Issues](https://github.com/your-username/laravel-gallery/issues)
- **📖 Documentation**: [Full Documentation](https://docs.gallery.example.com)

---

<div align="center">

**Built with ❤️ using Laravel, Vue.js, and modern web technologies**

*Transform your visual content management experience today.*

**Version:** 2.0.0 | **Laravel:** 10.x | **Vue:** 3.x | **PHP:** 8.1+

</div>

***

