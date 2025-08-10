# Acceleration-Based Behavioural Biometrics for Continuous User Authentication

## 📌 Overview
This project implements a **continuous user authentication system** using **acceleration-based behavioural biometrics**.  
It leverages motion data from device sensors (accelerometers) to identify an authorised user and reject impostors, without requiring repeated manual logins.

The system evaluates three feature domains:
- **Time Domain** – Statistical motion features
- **Frequency Domain** – Spectral motion features
- **Combined Time–Frequency Domain (TDFD)** – Fusion of statistical and spectral features

A **Feedforward Multi-Layer Perceptron (FFMLP)** neural network is trained and optimised to achieve high accuracy and low error rates in cross-day authentication scenarios.

---

## 🎯 Objectives
1. **Feature Analysis** – Identify stable (low intra-user variance) and distinctive (high inter-user variance) features.
2. **Model Evaluation** – Compare accuracy, FAR, FRR, and EER across all domains.
3. **Optimisation** – Improve the best-performing domain using:
   - Network architecture tuning
   - Feature scaling
   - Threshold adjustment
   - Feature selection (ReliefF)

---

## 📊 Key Results
- **Best Domain Before Optimisation:** Time–Frequency Domain (TDFD)  
  - Accuracy: **94.03% – 94.26%**
  - FRR: **0.83% – 1.11%**
  - EER: **3.78% – 3.92%**
- **Best Domain After Optimisation (TDFD):**  
  - Accuracy: **98.19% – 99.03%**
  - FAR: **1.06% – 2.00%**
  - FRR: **0.56% – 1.11%**
  - Several users achieved **100% accuracy** with zero error rates.

---

## 🛠️ Technologies Used
- **Programming Language:** MATLAB
- **Algorithm:** Feedforward Multi-Layer Perceptron (FFMLP)
- **Feature Selection:** ReliefF
- **Normalisation:** mapminmax
- **Performance Metrics:** Accuracy, FAR, FRR, EER

---

## 📂 Project Structure
AI-and-ML-Authentication-/
├─ Code Files/
│ ├─ Time Domain/
│ ├─ Frequency Domain/
│ └─ Time-Frequency Domain/
├─ Descriptive Statics/
├─ Templates/
│ ├─ Time Domain/
│ ├─ Frequency Domain/
│ └─ Time-Frequency Domain/
├─ Ashen Pulle-10899670-AI Referral.pdf
└─ Ashen Pulle-10899670-AI Referral.docx


## 🚀 How to Run
1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/AI-and-ML-Authentication-.git
   cd AI-and-ML-Authentication-
Open MATLAB and add the project folder to your path.

Run the training script for a chosen domain:

matlab
Copy
Edit
run('scripts/train_TDFD.m')
View the results in the MATLAB console or in the generated result tables.

📈 Optimisation Techniques Used
Increased hidden layers and neurons: [30, 20, 15]

Feature scaling with mapminmax for balanced training

Threshold tuning to minimise Equal Error Rate

ReliefF feature selection (top 50 features from 131)

📚 References
Al-Naffakh, N. et al. (2020) Activity-Based User Authentication Using Smartwatches.

Dos Santos, U.J.L. et al. (2022) Trends in user identity and continuous authentication.

Kang, T. et al. (2019) WearAuth: Wristwear-assisted user authentication using wavelet-based analysis.

Pelto, B. et al. (2023) Continuous user authentication based on machine learning and touch dynamics.

Siddiqui, N. et al. (2022) Continuous user authentication using mouse dynamics and deep learning.

📜 License
This project is licensed under the MIT License – you are free to use, modify, and distribute with attribution.

👤 Author
Ashen Pulle
BSc (Hons) Software Engineering
