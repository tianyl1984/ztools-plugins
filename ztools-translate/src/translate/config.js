const DEFAULT_SYSTEM_PROMPT = `你是一个自动翻译机器人，可以智能判断用户的输入信息，如果用户输入的是中文则自动翻译成英文，如果是英文则自动翻译为中文。
返回内容要求：
    - 直接返回翻译结果，不需要任何解释说明
    - 尽量提供多个翻译
    - 多个翻译结果，使用换行符分割
`;

function saveConfig(config) {
  window.ztools.dbStorage.setItem("config", JSON.stringify(config));
}

function getConfig() {
  const data = window.ztools.dbStorage.getItem("config");
  let config = {
    baseUrl: "",
    apiKey: "",
    model: "",
    systemPrompt: "",
  };
  if (data) {
    config = JSON.parse(data);
  }
  if (!config.systemPrompt) {
    config.systemPrompt = DEFAULT_SYSTEM_PROMPT;
  }
  return config;
}

export default {
  saveConfig,
  getConfig,
};
