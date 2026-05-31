<script setup>
import { ref, onMounted } from 'vue';
import configApi from './config.js';
defineProps({
    enterAction: {
        type: Object,
        required: true
    }
})

const config = ref({});
const emit = defineEmits();

const init = () => {
    config.value = configApi.getConfig();
}

const saveForm = () => {
    configApi.saveConfig(config.value);
    emit('updateShowConfig', false);
};

const cancelForm = () => {
    init();
    emit('updateShowConfig', false);
};

onMounted(() => {
    init()
});
</script>


<template>
    <div class="form-container">
        <form @submit.prevent="saveForm">
            <div class="form-group inline">
                <label for="base-url">Base URL:</label>
                <input id="base-url" type="text" v-model="config.baseUrl" placeholder="请输入 Base URL" />
            </div>

            <div class="form-group inline">
                <label for="api-key">API Key:</label>
                <input id="api-key" type="text" v-model="config.apiKey" placeholder="请输入 API Key" />
            </div>

            <div class="form-group inline">
                <label for="model">Model:</label>
                <input id="model" type="text" v-model="config.model" placeholder="请输入 Model" />
            </div>

            <div class="form-group">
                <label for="system-prompt">System Prompt:</label>
                <textarea id="system-prompt" v-model="config.systemPrompt" rows="8"
                    placeholder="请输入 System Prompt"></textarea>
            </div>

            <div class="form-actions">
                <button type="button" class="cancel-btn" @click="cancelForm">取消</button>
                <button type="submit" class="save-btn">保存</button>
            </div>
        </form>
    </div>
</template>

<style scoped>
.form-container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
    text-align: center;
    margin-bottom: 20px;
    color: #333;
}

.form-group {
    margin-bottom: 20px;
}

.form-group.inline {
    display: flex;
    align-items: center;
}

.form-group.inline label {
    width: 100px;
    margin-bottom: 0;
    margin-right: 10px;
    flex-shrink: 0;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: #333;
}

input,
textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
    background-color: #f9f9f9;
}

textarea {
    resize: vertical;
}

.form-actions {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 30px;
}

button {
    padding: 0px 20px;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.save-btn {
    background-color: #4caf50;
    color: white;
}

.save-btn:hover {
    background-color: #45a049;
}

.cancel-btn {
    background-color: #f44336;
    color: white;
}

.cancel-btn:hover {
    background-color: #d32f2f;
}
</style>
