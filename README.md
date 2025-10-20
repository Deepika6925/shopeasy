 🛒 EasyCart – Online Shopping Web Application

EasyCart is a **dynamic and user-friendly e-commerce web application** developed using **JSP, Servlets, and MySQL**. It allows users to **browse products, add them to their cart, place orders, and manage profiles**, while **admins** can manage products, orders, and users efficiently.

---

## 🌟 Features

### 👩‍💻 Customer Module

* 🔐 **Login & Registration**
* 🛍️ **View Products**
* 🛒 **Add to Cart & Manage Cart** (increase/decrease quantity)
* 💳 **Place Orders & View Order History**
* 👤 **Edit Profile with Profile Photo Upload**

### 🧑‍💼 Admin Module

* 📦 **Add, Update, or Delete Products**
* 📋 **View All Orders and Customers**
* 🧾 **Manage Inventory Efficiently**

---

## 🧰 Tech Stack

| Layer    | Technology                         |
| :------- | :--------------------------------- |
| Frontend | HTML, CSS, JSP                     |
| Backend  | Java, Servlet                      |
| Database | MySQL                              |
| Server   | Apache Tomcat 8.5+                 |
| IDE      | Eclipse / IntelliJ IDEA / NetBeans |

---

## 🗂️ Database Structure

### **Tables Used**

1. **users** – Stores user details (id, name(first,last), email, password, role, photo)
2. **products** – Stores product information (id, name, price, description, image)
3. **cart** – Stores user’s cart items (id, user_id, product_id, quantity)
4. **orders** – Stores placed orders and details

---

## ⚙️ Installation & Setup

### 🔽 Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/EasyCart.git
```

### 🧩 Step 2: Import the Project

* Open Eclipse / IntelliJ IDEA.
* Import as a **Dynamic Web Project**.
* Configure the **Apache Tomcat Server**.

### 🗄️ Step 3: Setup Database

1. Create a database named `shopeasy` in MySQL.
2. Run the SQL scripts provided in the `database.sql` file.
3. Update database credentials in `DBConnection.java`.

```java
String url = "jdbc:mysql://localhost:3306/shopeasy";
String user = "root";
String password = "yourpassword";
```

### 🚀 Step 4: Run the Project

* Start Apache Tomcat.
* Access the app at:
  👉 `http://localhost:8080/EasyCart/`

---

## 📸 Screenshots

|     Feature     |             Preview            |
| :-------------: | :----------------------------: |
|   🏠 Home Page  |    <img width="1115" height="527" alt="image" src="https://github.com/user-attachments/assets/900060b0-68d0-4074-920f-f5dd488319cb" />


|   🛒 Cart Page  |    <img width="1216" height="462" alt="image" src="https://github.com/user-attachments/assets/6f3159f1-0094-4742-bc09-4a74e435c55e" />

| 👤admin-dashboard Page | <img width="1342" height="640" alt="image" src="https://github.com/user-attachments/assets/8b49136b-ef49-4c66-941a-e462e1b1511f" />

---

## 📚 Future Enhancements

* 💰 Integrate Payment Gateway (Razorpay/Stripe)
* 📦 Add Product Categories & Filters
* 💬 Include Customer Reviews & Ratings
* 📱 Make UI Fully Responsive

---

## 🧑‍🎓 Author

👋 **Developed by:** Deepika
💡 *A passionate Computer Science Engineer exploring Web Development & Machine Learning.*
📧 Contact: [(mailto:deepika060925@gmail.com)]
🌐 GitHub: [https://github.com/Deepika6925](https://github.com/Deepika6925)


