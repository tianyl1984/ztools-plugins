<script setup>
import { onMounted, ref } from "vue";
import Translate from "./translate/index.vue";

const route = ref("");
const enterAction = ref({});

onMounted(() => {
  window.ztools.onPluginEnter((action) => {
    route.value = action.code;
    enterAction.value = action;
  });
  window.ztools.onPluginOut((isKill) => {
    route.value = "";
  });
});
</script>

<template>
  <template v-if="route === 'translate'">
    <Translate :enterAction="enterAction"></Translate>
  </template>
</template>
