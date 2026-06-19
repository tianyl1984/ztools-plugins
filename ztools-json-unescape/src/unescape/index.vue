<script setup>
import { ref, watch, onMounted, onUnmounted } from "vue";

const props = defineProps({
  enterAction: {
    type: Object,
    required: true,
  },
});

// ztools.setExpendHeight(60);
let input = "";
const result = ref("");

const convert = () => {
  try {
    let str = input;
    if (!input.startsWith('"')) {
      str = '"' + str + '"';
    }
    // if (!input.endsWith("\"") && ){
    //   str = str + "\"";
    // }
    let temp = JSON.parse(str);
    if (temp.startsWith("{") || temp.startsWith("[")) {
      try {
        result.value = JSON.stringify(JSON.parse(temp), null, 4);
      } catch (e1) {
        result.value = temp;
      }
    } else {
      result.value = temp;
    }
    // result.value = JSON.stringify(temp, null, 4);
  } catch (e) {
    result.value = "Invalid JSON: " + e.message;
  }
};

ztools.setSubInput(
  ({ text }) => {
    input = text;
    convert();
  },
  "输入转义后json",
  true,
);

// console.log(ztools);

watch(
  () => props.enterAction,
  (enterAction) => {
    if (enterAction.type === "over") {
      ztools.setSubInputValue(enterAction.payload);
      input = enterAction.payload;
      convert();
    }
  },
  {
    immediate: true,
  },
);

const handleEnter = async (event) => {
  if (event.key === "Enter") {
    ztools.copyText(result.value);
    ztools.outPlugin(false);
    ztools.hideMainWindow();
  }
};

onMounted(() => {
  window.addEventListener("keydown", handleEnter);
  // document.addEventListener("paste", (e) => {
  //   console.log("paste event", e);
  //   input = e.clipboardData.getData("text");
  //   convert();
  // });
});

onUnmounted(() => {
  window.removeEventListener("keydown", handleEnter);
});
</script>

<template>
  <div>
    <pre>{{ result }}</pre>
  </div>
</template>

<style>
html,
body {
  overflow-x: hidden;
  overflow-y: auto;
  width: 100%;
}
pre {
  font-size: 16px;
  line-height: 1.5;
  margin: 0;
  padding: 10px;
  background-color: #f5f5f5;
  color: #333;
  border-radius: 4px;
  overflow-x: auto;
  white-space: pre-wrap;
  word-wrap: break-word;
}

@media (prefers-color-scheme: dark) {
  pre {
    background-color: transparent;
    color: #e6e6e6;
  }
}
</style>
