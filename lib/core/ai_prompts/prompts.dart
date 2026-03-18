class Prompts {
  static String recommendationPrompt(){
    String prompt = "Analyze this financial data and return 3 actionable recommendations. Be specific and quantitative.";
    return prompt;
  }
  static String forecastPrompt(){
    String prompt = "Predict the financial outcome for the remaining days. Return risks and final balance.";
    return prompt;
  }
  static String adviceOnBuyPromptData(){
    String prompt = "Determine if the user can afford this purchase without financial risk.";
    return prompt;
  }
  static String transactionCategorizationPrompt(){
    String prompt = "Extract amount, tag, and the transaction category from this transaction.";
    return prompt;
  }
  static String insightDetectionPrompt(){
    String prompt = "Detect patterns and anomalies in this spending behavior.";
    return prompt;
  }
  static String weeklyReportPrompt(){
    String prompt = "Summarize this week's financial performance.";
    return prompt;
  }
}