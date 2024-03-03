<template>
    <router-view ref="routerView" v-slot="{Component}">
        <component :is="Component" :cnc="appData" />
    </router-view>
</template>

<script lang="ts">
import {ref, defineComponent} from "vue";
import {ElLoading} from "element-plus";
export default defineComponent({
    name: "App",
    emits: [],
    props: [],
    components: {},
    setup(props, context) {

        const appData: any = ref({
            loading: ElLoading.service({
                lock: true,
                background: "rgba(0, 0, 0, .5)",
                customClass: "desktop",
            }),
            data: false
        });

        return {
            props,
            appData
        }
    }
});
</script>

<style>
@import "./assets/css/base.scss";
</style>
