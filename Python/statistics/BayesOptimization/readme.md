Optimization like Grid Search but using Bayesian approach.<br>
Great to find best hyperparameter for model tuning.

Find good information at [Analytics Vidhya](https://www.analyticsvidhya.com/blog/2021/05/bayesian-optimization-bayes_opt-or-hyperopt/).


Using **F1-Score** as the optimization metric:

If you intend to calculate metrics like precision, recall, or F1-score, you need to specify *how to average the results across the different classes*.<br>
The sklearn.metrics module provides functions like precision_score, recall_score, and f1_score that have an average parameter.

Here's how you would use them correctly for a multi-class problem:

```python
# ... (rest of your code) ...

from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# ... (after getting y_pred) ...

test_accuracy = accuracy_score(y_test, y_pred)
print("\nTest accuracy with the best hyperparameters:")
print(test_accuracy)

# Calculate other metrics, specifying the 'average' parameter for multi-class
test_precision_macro = precision_score(y_test, y_pred, average='macro')
print("\nTest precision (macro-averaged):", test_precision_macro)

test_recall_macro = recall_score(y_test, y_pred, average='macro')
print("\nTest recall (macro-averaged):", test_recall_macro)

test_f1_macro = f1_score(y_test, y_pred, average='macro')
print("\nTest F1-score (macro-averaged):", test_f1_macro)

test_precision_weighted = precision_score(y_test, y_pred, average='weighted')
print("\nTest precision (weighted-averaged):", test_precision_weighted)

test_recall_weighted = recall_score(y_test, y_pred, average='weighted')
print("\nTest recall (weighted-averaged):", test_recall_weighted)

test_f1_weighted = f1_score(y_test, y_pred, average='weighted')
print("\nTest F1-score (weighted-averaged):", test_f1_weighted)
```
