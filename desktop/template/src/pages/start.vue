<template>
    <div class="flex h-screen flex-col bg-background select-none">
        <StartCommonHeader ref="startCommonHeader" :data="props.data" />
        <div class="flex-1 bg-background overflow-hidden overflow-y-auto">
            <div class="w-full p-8">
                <LoginPage ref="loginPage" :data="props.data" v-if="props.data.page.current === 'login'" />
            </div>
        </div>
        <div class="w-full h-6">
            <StartCommonFooter ref="startCommonFooter" :data="props.data" />
        </div>
    </div>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick} from "vue";
import StartCommonHeader from "./start/common/header.vue";
import LoginPage from "./start/login.vue";
import StartCommonFooter from "./start/common/footer.vue";

const props: any = defineProps<{
    data: any
}>();

props.data.base.ipc.on("message", (event: any, message: any) => {
    if(message.type === "switch:language"){
        if(props.data.base.lang.locale === "zh"){
            props.data.base.lang.locale = "en";
        }else{
            props.data.base.lang.locale = "zh";
        }
        localStorage.setItem("mir2:language", props.data.base.lang.locale);
    }
    if(message.type === "on:login"){
        onService();
    }
});

function onService(){
    props.data.browser.request("/desktop/check/index", "GET", {}, {}).then((request: any) => {
        if(request.status === 200){
            if (request.data.code === 0) {
                const data: any = request.data.data;
                if(data.account.token !== ""){
                    props.data.service.account.token = data.account.token;
                    props.data.page.current = "dashboard";
                }else{
                    props.data.service.account.token = "";
                    props.data.page.current = "login";
                }
            }else{
                props.data.browser.toast({
                    title: props.data.base.lang.t("common.tooltips"),
                    description: props.data.base.lang.t("common.status." + request.data.message),
                    variant: "warning",
                });
            }
        }else{
            props.data.browser.toast({
                title: props.data.base.lang.t("common.tooltips"),
                description: props.data.base.lang.t("common.abnormal"),
                variant: "error",
            });
        }
    });
}

onBeforeMount(() => {});

onMounted(() => {
    nextTick(() => {
        console.log("[template:index]", props);
        onService();
    });
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>
