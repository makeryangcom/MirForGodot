<template>
    <div style="padding: 20px"><Button disabled><Loader2 class="w-4 h-4 mr-2 animate-spin" />Button</Button></div>
</template>

<script lang="ts">
import {defineComponent, nextTick, onBeforeMount, onBeforeUnmount, onMounted, onUnmounted} from "vue";
import {ElLoading, ElMessage, ElNotification} from "element-plus";
import * as icons from "@element-plus/icons";
import { Button } from "@/component/ui/button";
import { Mail, Loader2 } from 'lucide-vue-next'
export default defineComponent({
    name: "Start",
    emits: [],
    props: ["cnc"],
    components: {
        Button,
        Mail,
        Loader2
    },
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
