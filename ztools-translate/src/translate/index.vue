<script setup>
import { ref, watch, onMounted, onUnmounted } from "vue";
import Config from "./config.vue";
import configApi from "./config.js";

const props = defineProps({
  enterAction: {
    type: Object,
    required: true,
  },
});

const configData = {
  id: 1,
  type: "config",
  text: "打开配置",
  select: false,
};

let input = "";
const listData = ref([]);
const showConfig = ref(false);

window.ztools.setExpendHeight(60);
watch(
  listData,
  (newVal, oldVal) => {
    window.ztools.setExpendHeight(newVal.length * 50 + 10);
  },
  { deep: false },
);

watch(
  showConfig,
  (newVal, oldVal) => {
    if (newVal) {
      window.ztools.setExpendHeight(500);
    } else {
      window.ztools.setExpendHeight(60);
    }
  },
  { deep: false },
);

listData.value.push(configData);

window.ztools.setSubInput(
  ({ text }) => {
    input = text;
  },
  "输入要翻译的文本，按enter查询",
  true,
);

watch(
  () => props.enterAction,
  (enterAction) => {
    if (enterAction.type === "over") {
      window.ztools.setSubInputValue(enterAction.payload);
      input = enterAction.payload;
    }
  },
  {
    immediate: true,
  },
);

const setDataList = (resultList, type) => {
  resultList = resultList.replace(/<think>[\s\S]*?<\/think>/g, "");
  let id = new Date().getTime();
  listData.value = [];
  for (const item of resultList.split("\n")) {
    if (item) {
      listData.value.push({
        id: id++,
        type: type ? type : "result",
        text: item,
        select: false,
      });
    }
  }
  listData.value.push(configData);
};

const handleEnter = async (event) => {
  if (event.key === "Enter") {
    // 选中列表时
    if (curSelIdx > -1) {
      handleDataSelect(listData.value[curSelIdx]);
      return;
    }
    try {
      await translate(input);
    } catch (error) {
      setDataList(error.message);
    }
  }
  if (event.key === "ArrowUp") {
    changeSelect(-1);
  }
  if (event.key === "ArrowDown") {
    changeSelect(1);
  }
};

const translate = async (text) => {
  if (text.trim().length === 0) {
    return;
  }
  const cfg = configApi.getConfig();
  // console.log(cfg)
  if (!(cfg.baseUrl && cfg.apiKey && cfg.model)) {
    showConfig.value = true;
    return;
  }
  setDataList("查询中", "loading");
  const response = await fetch(`${cfg.baseUrl}/chat/completions`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${cfg.apiKey}`,
    },
    body: JSON.stringify({
      model: cfg.model,
      messages: [
        { role: "system", content: cfg.systemPrompt },
        { role: "user", content: text },
      ],
    }),
  });
  if (!response.ok) {
    throw new Error(`HTTP 错误！状态码: ${response.status}`);
  }
  const data = await response.json();
  const resultList = data.choices[0].message.content;
  setDataList(resultList);
};

let curSelIdx = -1;
const changeSelect = (cnt) => {
  curSelIdx += cnt;
  curSelIdx = Math.max(curSelIdx, -1);
  curSelIdx = Math.min(curSelIdx, listData.value.length - 1);
  const data = listData.value.find((item) => item.select);
  if (data) {
    data.select = false;
  }
  if (curSelIdx != -1) {
    listData.value[curSelIdx].select = true;
  }
};

const handleDataSelect = (data) => {
  if (curSelIdx != -1) {
    listData.value[curSelIdx].select = false;
  }
  curSelIdx = -1;
  if (!data) {
    return;
  }
  if (data.type === "result") {
    window.ztools.copyText(data.text);
    window.ztools.outPlugin(false);
    window.ztools.hideMainWindow();
  }
  if (data.type === "config") {
    showConfig.value = true;
  }
  // console.log(data);
};

const updateShowConfig = (flag) => {
  showConfig.value = flag;
};

onMounted(() => {
  window.addEventListener("keydown", handleEnter);
  handleEnter({ key: "Enter" });
});

onUnmounted(() => {
  window.removeEventListener("keydown", handleEnter);
});
</script>

<template>
  <div v-if="!showConfig">
    <ul class="data-list">
      <li
        v-for="data in listData"
        :key="data.id"
        @click="handleDataSelect(data)"
        :class="{ selected: data.select, loading: data.type === 'loading' }"
      >
        {{ data.text }}
        <span v-if="data.type === 'loading'">.</span>
        <span v-if="data.type === 'loading'">.</span>
        <span v-if="data.type === 'loading'">.</span>
      </li>
    </ul>
  </div>
  <Config
    v-if="showConfig"
    :enterAction="enterAction"
    @update-show-config="updateShowConfig"
  ></Config>
</template>

<style>
html,
body {
  overflow-x: hidden;
  overflow-y: auto;
  width: 100%;
}

.data-list {
  width: 100%;
  font-size: 20px;
  padding: 0;
  margin: 0;
}

.data-list li {
  height: 50px;
  line-height: 50px;
  list-style: none;
  padding: 0 10px;
  margin: 0;
  width: 100%;
  cursor: pointer;
  white-space: nowrap;
}

.selected {
  background-color: rgb(220, 226, 230);
}

.loading span {
  animation: dots 1.5s steps(1, end) infinite;
}

.loading span:nth-child(1) {
  animation-delay: 0s;
}

.loading span:nth-child(2) {
  animation-delay: 0.5s;
}

.loading span:nth-child(3) {
  animation-delay: 1s;
}

@keyframes dots {
  0% {
    opacity: 0;
  }

  50% {
    opacity: 1;
  }

  100% {
    opacity: 0;
  }
}
</style>
