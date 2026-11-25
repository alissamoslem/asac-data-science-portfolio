# Hotel Booking Analysis and Machine Learning

![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge)
![BigQuery](https://img.shields.io/badge/Google_BigQuery-4285F4?style=for-the-badge&logo=googlebigquery&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine_Learning-F59E0B?style=for-the-badge)
![BigQuery ML](https://img.shields.io/badge/BigQuery_ML-34A853?style=for-the-badge)

## Project Overview

This project applies data analysis and machine learning to hotel booking data to support revenue management, pricing decisions, and customer segmentation.

Using SQL and Google BigQuery ML, I explored booking behavior, developed predictive models, evaluated their performance, and translated analytical findings into actionable business recommendations.

This project was completed as part of the ASAC Data Science Bootcamp at LTUC.

## Business Objectives

- Identify bookings that are likely to be cancelled.
- Understand the factors associated with booking cancellations.
- Predict hotel room prices per night.
- Identify customer segments for targeted marketing.
- Evaluate machine learning models based on business costs.
- Detect data leakage and consider responsible AI practices.

## Dataset Overview

The dataset contains 119,390 hotel bookings from 2015 to 2017, covering two types of hotels.

| Metric | Value |
|---|---:|
| Total bookings | 119,390 |
| City Hotel bookings | 79,330 |
| Resort Hotel bookings | 40,060 |
| Cancelled bookings | 44,224 |
| Overall cancellation rate | 37.0% |

### Dataset Splitting

The supervised learning models used separate training, validation, and testing datasets.

| Dataset | Records | Percentage |
|---|---:|---:|
| Training | 71,634 | 60% |
| Validation | 23,878 | 20% |
| Testing | 23,878 | 20% |

## Tools and Technologies

- Google BigQuery
- BigQuery ML
- GoogleSQL
- Logistic Regression
- Linear Regression
- K-Means Clustering
- Git and GitHub

## Exploratory Data Analysis

### Cancellation Rates by Hotel

| Hotel | Cancellation Rate |
|---|---:|
| City Hotel | 41.7% |
| Resort Hotel | 27.8% |
| Overall | 37.0% |

### Cancellation Rates by Lead Time

| Booking Lead Time | Cancellation Rate |
|---|---:|
| 0–7 days | 9.6% |
| 8–30 days | 27.9% |
| 31–90 days | 37.7% |
| 91–180 days | 44.7% |
| 181–365 days | 55.5% |
| Over one year | 67.7% |

The analysis revealed that bookings made further in advance were associated with higher cancellation rates.

Non-refundable bookings also showed a surprisingly high cancellation rate of 99.4%, highlighting the importance of investigating booking characteristics rather than assuming that deposits prevent cancellations.

## Machine Learning Models

### Model 1 — Hotel Cancellation Prediction

**Algorithm:** Logistic Regression

**Target variable:** `is_canceled`

The model predicts whether a hotel booking is likely to be cancelled using features intended to be available at booking time.

#### Model Performance

| Metric | Validation Result |
|---|---:|
| Accuracy | 75.84% |
| Precision | 91.63% |
| Recall | 38.19% |
| Baseline accuracy | 63.0% |

Although the model achieved high precision, its relatively low recall means that many actual cancellations were not detected.

For No Deposit bookings, the model achieved 72.6% accuracy, compared with 71.7% for the baseline.

This demonstrated why overall accuracy alone is insufficient for evaluating a classification model.

#### Data Leakage Detection

An initial model achieved 100% validation accuracy because it included information that was unavailable at booking time, such as `reservation_status`.

Potential leakage features investigated included:

- `reservation_status`
- `assigned_room_type`
- `required_car_parking_spaces`

The cancellation model excluded these features to better represent real-world prediction conditions.

#### Business Cost Optimization

Different classification thresholds were evaluated using the following assumed costs:

- False positive: €200
- False negative: €100

| Threshold | Estimated Validation Cost |
|---|---:|
| 0.3 | €1,231,000 |
| 0.4 | €739,900 |
| 0.5 | €607,600 |
| 0.6 | €598,900 |
| 0.7 | €597,600 |
| 0.8 | €611,700 |
| 0.9 | €708,500 |

A threshold of 0.7 was selected because it minimized the estimated cost
