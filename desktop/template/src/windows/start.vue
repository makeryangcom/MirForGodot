<template>
    <div>Hello</div>
</template>

<script lang="ts">
import {defineComponent, nextTick, onBeforeMount, onBeforeUnmount, onMounted, onUnmounted} from "vue";
import {ElLoading, ElMessage, ElNotification} from "element-plus";
import * as icons from "@element-plus/icons";
export default defineComponent({
    name: "Start",
    emits: [],
    props: ["cnc"],
    components: {},
    setup(props, context) {

        onBeforeMount(() => {
            props.cnc.loading = ElLoading.service({
                lock: true,
                background: "rgba(0, 0, 0, .5)",
                customClass: "desktop",
                fullscreen: true
            });
        });

        onMounted(() => {
            nextTick(()=>{
                props.cnc.loading.close();
            });
        });

        onBeforeUnmount(()=>{})

        onUnmounted(() => {});

        return {
            props,
            icons
        }
    }
});
</script>

<style scoped>

</style>
