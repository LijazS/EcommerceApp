# EcommerceApp — Docker Deployment Guide (No Docker Compose)

## Prerequisites
- Docker installed and running
- You are in the `EcommerceApp/` directory (the one containing `Dockerfile`, `pom.xml`, `db/`)

---

## Step 1 — Create a dedicated Docker network

Both containers must share a network so the app can reach the database by container name.

```bash
docker network create ecommerce-net
```

---

## Step 2 — Start the MySQL container

```bash
docker run -d \
  --name ecommerce_db \
  --network ecommerce-net \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=ecommerce \
  -e MYSQL_USER=ecommerce \
  -e MYSQL_PASSWORD=ecommerce \
  -v ecommerce_db_data:/var/lib/mysql \
  -v "$(pwd)/db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
  -p 3306:3306 \
  mysql:8.0
```

> **Windows PowerShell note:** Replace `$(pwd)` with `${PWD}` or the full absolute path, e.g.:
> ```powershell
> -v "C:\Users\lijaz\Desktop\DEVOPS\EcommerceApp\EcommerceApp\db\init.sql:/docker-entrypoint-initdb.d/init.sql:ro"
> ```

Wait ~20–30 seconds for MySQL to initialize. You can check readiness with:

```bash
docker logs ecommerce_db
# Look for: "ready for connections"
```

---

## Step 3 — Build the application image

```bash
docker build -t ecommerce-app .
```

---

## Step 4 — Run the application container

```bash
docker run -d \
  --name ecommerce_app \
  --network ecommerce-net \
  -e DB_URL="jdbc:mysql://ecommerce_db:3306/ecommerce?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true" \
  -e DB_USER=ecommerce \
  -e DB_PASS=ecommerce \
  -p 8080:8080 \
  ecommerce-app
```

The app is now accessible at: **http://localhost:8080**

---

## Checking logs

```bash
docker logs ecommerce_app
docker logs ecommerce_db
```

---

## Verify MySQL schema was created

```bash
docker exec -it ecommerce_db mysql -uecommerce -pecommerce ecommerce -e "SHOW TABLES;"
```

Expected output:
```
Tables_in_ecommerce
brand
cart
category
contactus
customer
order_details
orders
product
```

---

## Teardown

```bash
# Stop and remove containers
docker stop ecommerce_app ecommerce_db
docker rm ecommerce_app ecommerce_db

# Remove the network
docker network rm ecommerce-net

# (Optional) Remove the DB volume — this deletes all data!
docker volume rm ecommerce_db_data
```

---

## Environment Variable Reference

| Variable | Value used | Purpose |
|---|---|---|
| `DB_URL` | `jdbc:mysql://ecommerce_db:3306/ecommerce?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true` | JDBC URL; `ecommerce_db` resolves to the MySQL container via the Docker network |
| `DB_USER` | `ecommerce` | MySQL user |
| `DB_PASS` | `ecommerce` | MySQL password |

> If `DB_URL` is **not set**, the app falls back to SQLite at `/data/mydatabase.db` inside the container.
