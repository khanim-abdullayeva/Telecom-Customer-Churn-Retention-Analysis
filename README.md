# Telecom Customer Churn & Retention Analysis

## Project Overview

Customer churn is a major challenge for telecommunications companies because losing customers can reduce revenue and increase customer acquisition costs. Identifying customers who are likely to leave allows businesses to take proactive retention measures.

This project analyzes customer data and develops machine learning classification models to predict customer churn. It also explores different classification thresholds to improve the detection of customers at risk of leaving.

## Objectives

- Explore customer behavior and identify patterns associated with churn.
- Prepare the dataset for machine learning.
- Build and evaluate multiple classification models.
- Compare model performance using relevant evaluation metrics.
- Optimize the classification threshold to improve churn detection.
- Identify how predictive analytics can support customer retention strategies.

## Dataset

The dataset contains **3,333 customer records** and 11 columns, including the target variable `churn`.

Selected features include:

- `account_weeks` — customer account duration.
- `contract_renewal` — contract renewal status.
- `data_usage` — customer data usage.
- `cust_serv_calls` — number of customer service calls.
- `day_mins` — daytime minutes used.
- `monthly_charge` — monthly customer charge.
- `overage_fee` — additional usage charges.

The target variable is `churn`, which indicates whether a customer has churned.

The target classes are imbalanced:
- **Non-churn customers:** 2,850
- **Churn customers:** 483

This class imbalance makes recall, precision, and F1-score particularly important when evaluating model performance.

## Tools & Technologies

- **Python** — data analysis and machine learning
- **Jupyter Notebook** — experimentation and documentation
- **Pandas** — data manipulation, depending on the operations used in the notebook
- **Scikit-learn** — preprocessing, model training, and evaluation
- **Matplotlib** — visualizations, where used
- **Git & GitHub** — version control and project sharing

## Project Workflow

### 1. Data Exploration and Preparation

The dataset was inspected to understand its structure, target distribution, and relevant customer attributes. Features were selected for model development, and the data was split into training and testing sets.

A stratified train-test split was used to preserve the churn class distribution:

- Test size: 20%
- Random state: 42
- Stratification: target variable `churn`

### 2. Model Development

Several classification models and configurations were evaluated:

- Logistic Regression
- Balanced Logistic Regression
- Random Forest
- Balanced Random Forest
- Gradient Boosting
- Weighted Gradient Boosting

Class imbalance was addressed using balanced model configurations and sample weighting where appropriate.

### 3. Model Evaluation

Models were evaluated using:

- **Accuracy** — proportion of correctly classified customers.
- **Precision** — proportion of predicted churners who actually churned.
- **Recall** — proportion of actual churners identified by the model.
- **F1-score** — harmonic mean of precision and recall.
- **ROC-AUC** — ability to distinguish between churn and non-churn customers across classification thresholds.

Accuracy alone is insufficient for an imbalanced dataset, as a model can achieve high accuracy while missing many actual churners.

## Model Comparison

The following results were obtained on the test set using the standard classification threshold of 0.50.

| Model | Accuracy | Precision | Recall | F1-score | ROC-AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 85.76% | 52.63% | 20.62% | 29.63% | 0.81 |
| Balanced Logistic Regression | 76.01% | 34.78% | 74.23% | 47.37% | 0.81 |
| Random Forest | 92.50% | 82.19% | 61.86% | 70.59% | 0.86 |
| Balanced Random Forest | 92.80% | 84.51% | 61.86% | 71.43% | 0.86 |
| Gradient Boosting | 92.05% | 76.19% | 65.98% | 70.72% | 0.86 |
| Weighted Gradient Boosting | 85.76% | 50.68% | 77.32% | 61.22% | 0.86 |

The Balanced Random Forest achieved the highest F1-score and precision among these configurations at the 0.50 threshold. The weighted Gradient Boosting model achieved higher recall, identifying a larger proportion of actual churners.

## Classification Threshold Optimization

The default classification threshold of 0.50 is not always the best choice for churn prediction. Lowering the threshold can help identify more potential churners, although it may also increase false positives.

The weighted Gradient Boosting model was evaluated at different thresholds. Based on the tested thresholds, **0.45 produced the highest F1-score** while maintaining a high recall.

### Results at a threshold of 0.45

| Metric | Result |
|---|---:|
| Accuracy | 85.61% |
| Precision | 50.33% |
| Recall | 79.38% |
| F1-score | 61.60% |
| ROC-AUC | 0.86 |

### Confusion Matrix

| | Predicted: No Churn | Predicted: Churn |
|---|---:|---:|
| Actual: No Churn | 494 | 76 |
| Actual: Churn | 20 | 77 |

At this threshold, the model correctly identified **77 of the 97 actual churners** in the test set, while missing 20 churn cases. It also flagged 76 non-churn customers as potential churners.

This illustrates the trade-off between identifying more at-risk customers and generating additional false-positive predictions.

## Key Findings

- The dataset contains an imbalanced target, with substantially fewer churners than non-churners.
- Logistic Regression at the default threshold showed relatively low recall, demonstrating why accuracy alone is not sufficient for churn prediction.
- Balanced Random Forest delivered the strongest overall precision and F1-score at the default threshold among the evaluated configurations.
- Weighted Gradient Boosting achieved 79.38% recall at a threshold of 0.45.
- Threshold selection affects the balance between missed churners and customers incorrectly flagged as at risk.

## Business Recommendations

Based on the model evaluation, a telecommunications company could:

1. Prioritize high-risk customers for targeted retention campaigns.
2. Investigate customer service interactions as a potential signal of churn risk.
3. Review contract renewal behavior, account duration, and customer charges to identify useful retention opportunities.
4. Choose a classification threshold according to the cost of missed churners versus unnecessary retention offers.
5. Monitor model performance over time and retrain the model when customer behavior changes.

These recommendations are hypotheses for business action based on model outputs, not proof that any individual feature causes churn.

## Limitations

- Model performance was evaluated on a held-out test set and may differ on new customer data.
- False-positive predictions may result in unnecessary retention costs.
- The chosen threshold depends on business priorities and should be validated against real campaign outcomes.
- Predictive associations do not establish causal relationships.

## Future Improvements

- Build an interactive dashboard to explore churn patterns and customer segments.
- Visualize feature importance and investigate model interpretability.
- Evaluate additional models and tune hyperparameters.
- Validate the selected threshold using business costs and retention campaign outcomes.
- Develop a workflow for scoring new customers and monitoring model performance.

## Conclusion

This project demonstrates an end-to-end machine learning workflow for telecom customer churn analysis, from data preparation and model comparison to threshold optimization.

The results show that the best model depends on the objective: Balanced Random Forest performed best in terms of F1-score at the default threshold, while weighted Gradient Boosting at a threshold of 0.45 offered higher recall. The final business choice should reflect the relative costs of missed churners and false-positive predictions.

---

**Author:** Khanim Abdullayeva

**GitHub:** [khanim-abdullayeva](https://github.com/khanim-abdullayeva)
