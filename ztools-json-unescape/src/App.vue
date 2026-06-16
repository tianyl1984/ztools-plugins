<script setup>
import { onMounted, ref } from "vue";
import Unescape from "./unescape/index.vue";

const route = ref("");
const enterAction = ref({});

onMounted(() => {
  window.ztools.onPluginEnter((action) => {
    route.value = action.code;
    enterAction.value = action;
    // console.log(route.value);
    // console.log(action);
    // alert(route.value)
  });
  window.ztools.onPluginOut((isKill) => {
    route.value = "";
  });
});
</script>

<template>
  <template v-if="route === 'unescape'">
    <Unescape :enterAction="enterAction"></Unescape>
  </template>
</template>
