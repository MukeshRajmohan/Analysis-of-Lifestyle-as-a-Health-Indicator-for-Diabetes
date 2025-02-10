# 📊 Analysis of Lifestyle as a Health Indicator for Diabetes

## 📌 Project Overview
This study evaluates the **top 10 lifestyle factors** influencing **diabetes prevalence** in the **American population**. We explore various **machine learning models** to determine the best predictive model for diabetes diagnosis based on lifestyle attributes.

### 🎯 Objectives:
- Identify **key lifestyle factors** affecting diabetes.
- Apply **data mining models** to predict diabetes risk.
- Compare model performances using **ROC curve, precision, and recall**.

---

## 📂 Project Files
- **📄 Final Report:** `HAP_780_Team_14.docx`
- **📊 Presentation:** `HAP_780_Team_14.pptx`
- **📜 SQL Queries (Data Preprocessing):** `HAP_780_Team_14.sql`
- **📂 Training & Testing Datasets (Weka):**  
  - `diabetes_class_train.arff`
  - `diabetes_class_test.arff`
  - `diabetes_train_final.arff`
  - `diabetes_test_final.arff`

---

## 🔑 Key Features
- **📊 Dataset Analysis:** CDC’s **Diabetic Health Indicators** dataset with **253,680 samples & 23 variables**.
- **🧹 Data Cleaning & Processing:** SQL-based **feature selection, missing value handling, and normalization**.
- **🧠 Predictive Modeling:** Trained **6 machine learning models** in **Weka**:
  - **Logistic Regression**
  - **Naïve Bayes**
  - **Decision Tree**
  - **J48**
  - **Random Forest**
  - **Random Tree**
- **📈 Model Evaluation:** Compared models using **ROC curve, precision, and recall**.

---

## 🗃️ Dataset Information
- **Source:** [CDC - Diabetic Health Indicators Dataset](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
- **Sample Size:** **253,680**
- **Independent Variables:**
  - **Lifestyle Factors:** Obesity, Physical Activity, Diet, Smoking, Alcohol Consumption.
  - **Health Metrics:** BMI, Blood Pressure, Cholesterol, General Health.
- **Dependent Variable:**
  - **Diabetes Classification:** No Diabetes, Pre-Diabetes, Diabetes.

---

## 🔧 Project Workflow

### **1️⃣ Data Preprocessing (SQL)**
- **Data Import:** PostgreSQL database for structured analysis.
- **Missing & Duplicate Check:** No missing values or duplicate entries detected.
- **Binary Variable Validation:** Ensured consistency in categorical variables.
- **Feature Engineering:**
  - **Age Categorization:** Grouped into **Young, Middle-aged, Older**.
  - **Education & Income Levels:** Mapped into **descriptive categories**.
  - **Lifestyle Score Calculation:** Combined **Fruits, Veggies, Physical Activity** scores.

### **2️⃣ Machine Learning Modeling (Weka)**
- **Feature Selection:** Used **CorrelationAttributeEval** to identify **top 10 features**.
- **Training & Testing Split:** 80% data for training, 20% for testing.
- **Model Training:** Applied **6 classifiers**.
- **Evaluation Metrics:** Used **ROC curve, precision, and recall** for performance comparison.

---

## 📈 Model Performance Comparison

| Model             | ROC Area | Precision | Recall  |
|------------------|----------|----------|---------|
| **Logistic Regression** | **0.797**  | 0.860    | **0.975**  |
| Naïve Bayes     | 0.783    | **0.895** | 0.859   |
| Decision Tree   | 0.790    | 0.854    | **0.986**  |
| J48             | 0.709    | 0.855    | 0.983   |
| Random Forest   | 0.759    | 0.863    | 0.955   |
| Random Tree     | 0.700    | 0.861    | 0.957   |

### **Key Takeaways**
- **Logistic Regression** is the most **reliable** model (**Best ROC Area** & **high recall**).
- **Naïve Bayes** provides the **best precision**, reducing false positives.
- **Decision Tree** excels in **recall**, capturing most positive cases.

---

## 🔄 Automation & Enhancements
- **📊 Advanced Feature Selection:** Incorporate **mutual information-based selection**.
- **⚡ Improved ML Models:** Experiment with **Gradient Boosting & Neural Networks**.
- **🏥 Real-World Deployment:** Integrate with **electronic health records (EHRs)**.
- **🧩 Multi-Disease Analysis:** Expand to cover **heart disease & hypertension**.

---

## ⚙️ How to Run the Project

### **1️⃣ Prerequisites**
- **PostgreSQL** (for SQL preprocessing).
- **Weka 3.8** (for ML model training).

### **2️⃣ SQL Execution**
1. **Load the dataset** into PostgreSQL.
2. **Run** `HAP_780_Team_14.sql` to preprocess data.

### **3️⃣ Running Machine Learning Models in Weka**
1. Import `diabetes_train_final.arff` for training.
2. Import `diabetes_test_final.arff` for testing.
3. Apply classifiers in Weka.
4. Compare results using **ROC Curve, Precision & Recall**.

---

## 📚 References
- **[CDC Diabetes Health Indicators Dataset](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)**
- **[Diabetes Health Indicators - Kaggle](https://www.kaggle.com/datasets/alexteboul/diabetes-health-indicators-dataset)**
- **[Weka - CorrelationAttributeEval Feature Selection](https://weka.sourceforge.io/doc.dev/weka/attributeSelection/CorrelationAttributeEval.html)**
- **[Weka API Documentation](https://weka.sourceforge.io/doc.dev/index.html?weka/attributeSelection/CorrelationAttributeEval.html)**

---

## 🤝 Contributors

### 🏫 **George Mason University - HAP 780**
- 👤 **Mukesh Rajmohan**  
- 👤 **Priyanka Avagadda** 
- 👤 **Pranavi Rao Lingala** 

For any questions or contributions, feel free to **raise an issue!** 🚀
