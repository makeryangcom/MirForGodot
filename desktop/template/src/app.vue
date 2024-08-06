<template>
    <router-view ref="routerView" v-slot="{Component}">
        <component :is="Component" :data="data" :base="base" />
    </router-view>
    <Toaster ref="toaster" />
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick, ref} from "vue";
import {useRoute, useRouter, useI18n, useDark, useStore, Request, ThemeColors} from "./packages";
import {useForm, toTypedSchema, object, string} from "./packages";
import {Toaster, useToast} from "@/lib/toast";

const $route = useRoute();
const $router = useRouter();
const $store = useStore();
const {toast} = useToast();

const i18n = useI18n();
const base: any = (window as any).base;
const data: any = ref({
    base: (window as any).base,
    route: $route,
    router: $router,
    store: $store,
    theme: {
        colors: ThemeColors,
        dark: useDark()
    },
    header: {
        search: {
            status: false
        }
    },
    page: {
        current: "",
        login: {
            type: "login",
            code: {
                timer: null,
                count: 60,
                loading: false
            },
            loading: false
        }
    },
    service: {
        loading: false,
        account: {
            token: ""
        },
    },
    browser: {
        language: (navigator as any).language,
        toast: toast,
        request: Request,
        form: {
            use: useForm,
            schema: toTypedSchema,
            object: object,
            string: string
        },
        network: {
            status: false
        }
    }
});

onBeforeMount(() => {});

onMounted(() => {
    data.value.base.process = process;
    console.log("Mir2Tools " + data.value.browser.language + " " + data.value.base.environment(process) + " " + data.value.base.config.version + " " + data.value.base.config.author);
    console.log("Platform:" + data.value.base.platform + " Electron:" + data.value.base.process.versions.electron + " Chromium:" + data.value.base.process.versions.chrome + " NodeJS:" + data.value.base.process.versions.node);
    console.log("Path:" + data.value.base.app_path(process) + " Data:" + data.value.base.app_data_path(process) + " Home:" + data.value.base.app_home_path(process) + " Temp:" + data.value.base.app_temp_path(process));
    document.documentElement.style.setProperty("--radius", `${$store.radius.value}rem`);
    document.documentElement.classList.add(`theme-${$store.theme.value}`);
    nextTick(() => {
        data.value.base.lang.t = i18n.t;
        data.value.base.lang.locale = i18n.locale;
        if(data.value.base.lang.locale === "null"){
            if(data.value.browser.language === "zh-CN"){
                data.value.base.lang.locale = "zh";
            }else{
                data.value.base.lang.locale = "en";
            }
        }
        window.addEventListener("resize", function() {
            data.value.base.ipc.send("message", {type: "header:right:button", data: "resize"});
        });
    });
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>

<style>
@import url("./assets/css/shiki.css");
@import url("./assets/css/tailwind.css");
@import url("./assets/css/themes.css");
@import url("./assets/css/markdown.css");
</style>
