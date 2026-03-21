# AWS Platform Foundation

Infrastructure as Code pour AWS utilisant Terraform, avec déploiement automatisé via GitHub Actions.

## 📋 Table des matières

- [Prérequis](#prérequis)
- [Architecture](#architecture)
- [Composants principaux](#composants-principaux)
- [Configuration AWS](#configuration-aws)
- [Backend Terraform](#backend-terraform)
- [Structure du projet](#structure-du-projet)
- [Déploiement](#déploiement)
- [Site web statique](#site-web-statique)
- [CI/CD](#cicd)
- [Gestion du State](#gestion-du-state)
- [Sécurité](#sécurité)
- [Nettoyage](#nettoyage)
- [Commandes utiles](#commandes-utiles)

---

## 🔧 Prérequis

- **AWS Account** avec accès administrateur
- **AWS CLI** v2+
- **Terraform** v1.0.0+
- **Git** et compte GitHub
- **PowerShell** (Windows) ou Bash (Linux/Mac)

---

## 🏗️ Architecture

GitHub Actions → Terraform → AWS S3 → Site Web Statique

### Composants principaux :
- **S3 Bucket** : Stockage du site statique
- **S3 Backend** : Stockage centralisé du state Terraform
- **GitHub Actions** : CI/CD automatisé
- **Terraform Modules** : Infrastructure réutilisable

---

## ⚙️ Configuration AWS

### 1. Créer un utilisateur IAM

```bash
aws iam create-user --user-name terraform-user

###2. Attacher les permissions
aws iam attach-user-policy \
  --user-name terraform-user \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

###3. Créer les clés d'accès
aws iam create-access-key --user-name terraform-user

⚠️ Sauvegarde les clés :
{
  "AccessKeyId": "..."
  "SecretAccessKey": "***********"
}
4. Configurer AWS CLI localement
AWS Access Key ID: AKIA...
AWS Secret Access Key: ...
Default region: us-east-1
Default output format: json

###5. Vérifier la connexion
aws sts get-caller-identity

### Backend Terraform
Création du bucket S3 pour le state
aws s3api create-bucket \
  --bucket terraform-state-mohamed-2025 \
  --region us-east-1

###Activer le versioning
aws s3api put-bucket-versioning \
  --bucket terraform-state-mohamed-2025 \
  --versioning-configuration Status=Enabled

###Activer le chiffrement
aws s3api put-bucket-encryption \
  --bucket terraform-state-mohamed-2025 \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

###Configuration du backend dans Terraform
###Fichier : backend.tf
terraform {
  backend "s3" {
    bucket  = "terraform-state-mohamed-2025"
    key     = "static-site/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

###📁 Structure du projet
aws-platform-foundation/
├── .github/
│   └── workflows/
│       └── terraform.yml          # Pipeline CI/CD
├── modules/
│   └── storage/
│       └── s3-static-site/
│           ├── main.tf            # Ressources S3
│           ├── variables.tf       # Variables du module
│           └── outputs.tf         # Outputs du module
├── stacks/
│   └── static-site/
│       ├── backend.tf             # Configuration backend S3
│       ├── main.tf                # Appel du module
│       ├── variables.tf           # Variables du stack
│       ├── terraform.tfvars       # Valeurs des variables
│       └── website/
│           └── index.html         # Site web
└── README.md

###🚀 Déploiement
1. Initialiser Terraform
cd stacks/static-site
terraform init

2. Planifier les changements
terraform plan

3. Appliquer l'infrastructure
terraform plan

4. Récupérer l'URL du site
terraform output website_url

🌐 Site web statique
Upload manuel du contenu
aws s3 cp stacks/static-site/website/index.html \
  s3://mystaticwebsite2036/ \
  --content-type "text/html; charset=utf-8"

###Vérifier le contenu
aws s3 ls s3://mystaticwebsite2036/

###Accéder au site
http://mystaticwebsite2036.s3-website-us-east-1.amazonaws.com

###🔄 CI/CD avec GitHub Actions
Configuration des secrets GitHub
GitHub → Settings → Secrets and variables → Actions
Ajouter les secrets :
AWS_ACCESS_KEY_ID : Clé d'accès AWS
AWS_SECRET_ACCESS_KEY : Clé secrète AWS
Workflow automatique
Fichier : terraform.yml

###Déclencheurs :
✅ Push sur main → Terraform Plan automatique
✅ Workflow manuel → Terraform Apply
Jobs :
terraform-plan : Validation et planification
terraform-apply : Déploiement (manuel uniquement)
Lancer un déploiement manuel
GitHub → Actions
Terraform CI/CD → Run workflow
Run workflow ✅
📊 Gestion du State
Voir l'état actuel
terraform state list

###Voir les détails d'une ressource
terraform state show aws_s3_bucket.website

###Télécharger le state depuis S3
aws s3 cp s3://terraform-state-mohamed-2025/static-site/terraform.tfstate .

###🛡️ Sécurité
Bonnes pratiques à appliquées :
✅ Chiffrement : State et bucket chiffrés avec AES256
✅ Versioning : Historique des states activé
✅ IAM : Utilisateur dédié avec permissions minimales
✅ Secrets : Clés AWS stockées dans GitHub Secrets
✅ Backend distant : State centralisé sur S3

Pour Bloquer l'accès public au bucket de state
aws s3api put-public-access-block \
  --bucket terraform-state-mohamed-2025 \
  --public-access-block-configuration \
  "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

 note ! : non appliqué pour ce projet. 

###🧹 Nettoyage
###Détruire l'infrastructure
cd stacks/static-site
terraform destroy
### 🔴 Détruire l'infrastructure

#### **Option 1 : Via GitHub Actions (Recommandé)**

1. Va sur **GitHub** → **Actions**
2. Clique sur **"Terraform Destroy"** (dans la liste à gauche)
3. Clique sur **"Run workflow"**
4. Sélectionne la branche **main**
5. Clique sur **"Run workflow"**

Le workflow va automatiquement :
- Se connecter au backend S3
- Initialiser Terraform
- Vider et détruire le bucket S3 (grâce à `force_destroy = true`)
- Mettre à jour le state S3

---

#### **Option 2 : En local**

```bash
# Se placer dans le répertoire du stack
cd stacks/static-site

# Initialiser Terraform 
terraform init

# Détruire l'infrastructure
terraform destroy

# Confirmer avec 'yes'

###Supprimer le bucket de state
aws s3 rb s3://terraform-state-mohamed-2025 --force

###📝 Commandes utiles
terraform init              # Initialiser
terraform plan              # Planifier les changements
terraform apply             # Appliquer les changements
terraform destroy           # Détruire l'infrastructure
terraform output            # Afficher les outputs
terraform state list        # Lister les ressources
terraform state show <resource>  # Détails d'une ressource

###AWS CLI
aws s3 ls                   # Lister les buckets S3
aws s3 cp <src> <dest>      # Copier un fichier
aws sts get-caller-identity # Vérifier l'identité AWS
aws s3 rb s3://<bucket> --force  # Supprimer un bucket

###👤 Auteur
Mohamed Belhedi
DevOps Engineer | Cloud Architecture | Infrastructure as Code

🔗 LinkedIn https://www.linkedin.com/in/mohamed-%E2%84%A2-17986b94/

###📄Licence
Ce projet est sous licence MIT.

```markdown
---

## 🆘 Problèmes courants

### ❌ Error: Access Denied
➡️ Vérifier les permissions IAM et la validité des clés AWS

### ❌ Error: Bucket already exists
➡️ Le nom du bucket S3 doit être **unique globalement**. Modifier la variable `bucket_name`.

### ❌ Error: Backend initialization failed
➡️ Vérifier que le bucket de state existe et que les permissions sont correctes.

### ❌ Error: Resource already managed by Terraform
➡️ Utiliser `terraform import` pour importer la ressource existante dans le state.

### ❌ Workflow failed
➡️ Vérifier les secrets GitHub : `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

### ❌ State locked
➡️ Attendre la fin du job précédent ou forcer l'unlock :
```bash
terraform force-unlock <LOCK_ID>