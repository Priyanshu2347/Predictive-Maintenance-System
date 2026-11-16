# Predictive Maintenance System Using MATLAB

### An Intelligent Machine Health Monitoring and Failure Prediction Platform

## 1. Project Overview

The Predictive Maintenance System is a software-based machine monitoring and analytics platform developed using MATLAB. It analyzes historical industrial machine sensor data to estimate Remaining Useful Life (RUL), classify machine risk levels, detect unusual sensor behaviour, and generate maintenance recommendations.

## 2. Key Features

- Remaining Useful Life prediction using machine learning.
- High, Medium, and Low RUL-based risk classification.
- Sensor trend monitoring and anomaly detection.
- Automated maintenance recommendations.
- Machine priority ranking and high-risk alerts.
- Interactive MATLAB dashboard.
- Feature importance visualization.
- CSV-based machine reports.

## 3. Technologies Used

- MATLAB Online
- MATLAB Object-Oriented Programming
- MATLAB Statistics and Machine Learning Toolbox
- MATLAB App Designer / UI components
- NASA C-MAPSS turbofan engine dataset

## 4. Machine Learning Models

### RUL Prediction
Regression models were evaluated, including Regression Tree, Bagged Trees, and Boosted Trees. Bagged Trees was selected for the final RUL prediction system.

### Risk Classification
Classification Tree, Bagged Ensemble, and AdaBoostM2 models were evaluated. Bagged Trees was selected for the final risk classification system.

Risk categories are derived from RUL thresholds:
- High: RUL ≤ 30 cycles
- Medium: 30 < RUL ≤ 60 cycles
- Low: RUL > 60 cycles

## 5. Dashboard Features

The interactive dashboard provides:
- Total engine and risk-category statistics.
- RUL prediction visualization.
- Risk distribution chart.
- Feature importance chart.
- Machine prediction records.
- Critical machine alerts.
- Individual sensor monitoring.

## 6. Dataset

The project uses the NASA C-MAPSS FD002 turbofan engine dataset, containing historical operating cycles, operating settings, and sensor measurements.

## 7. Project Structure

```text
predictive-maintenance-system/
├── +maintenance/
│   ├── +core/
│   ├── +io/
│   ├── +analytics/
│   └── +utils/
├── app/
│   ├── maintenance_dashboard.m
│   ├── maintenance_dashboard_backup.m
│   └── sensor_monitor.m
└── data/
    ├── CMAPSSData/
    ├── machine_data.csv
    ├── processed_machine_data.csv
    ├── final_prediction_results.mat
    ├── complete_machine_results.mat
    ├── final_machine_report.csv
    └── high_risk_alerts.csv
```

## 8. Limitations

The risk categories are based on RUL thresholds and should not be interpreted as calibrated probabilities of failure. Sensor anomaly thresholds are heuristic. Model performance on the NASA dataset does not guarantee equivalent performance on real industrial machinery.

## 9. Future Enhancements

- Improve Medium-risk classification performance.
- Add real-time sensor data integration.
- Develop more advanced failure forecasting.
- Add configurable maintenance alert thresholds.
- Expand the dashboard with additional diagnostic analytics.

## 10. Project Outcome

The project demonstrates an integrated predictive maintenance workflow combining historical sensor data analysis, machine learning, RUL estimation, risk classification, anomaly detection, and interactive visualization in MATLAB.
