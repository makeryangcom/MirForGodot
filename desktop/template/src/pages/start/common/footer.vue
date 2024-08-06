<template>
    <div class="w-full h-[23px] border-t border-border flex items-center text-xs space-x-5 bg-muted/50 px-2 text-muted-foreground">
        <div class="flex space-x-2 items-center">
            <span class="col-auto">Development</span>
            <span class="col-auto">
                <CheckIcon class="w-3 h-3" v-if="props.data.browser.network.status" />
                <Cross2Icon class="w-3 h-3 text-yellow-500" v-else />
            </span>
        </div>
        <div class="flex space-x-2 items-center">
            <span class="col-auto">Service</span>
            <span class="col-auto">
                <CheckIcon class="w-3 h-3" v-if="props.data.browser.network.status" />
                <Cross2Icon class="w-3 h-3 text-yellow-500" v-else />
            </span>
        </div>
        <div class="grow"></div>
        <div class="grow"></div>
        <div class="grow"></div>
        <div class="grow"></div>
        <div class="grow"></div>
        <div class="grow text-right">
            <span class="mr-1">Version</span>
            <span>{{props.data.base.config.version}}</span>
        </div>
    </div>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick} from "vue";
import {CheckIcon, Cross2Icon} from "@radix-icons/vue";

const props: any = defineProps<{
    data: any
}>();

onBeforeMount(() => {});

onMounted(() => {
    nextTick(() => {});
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>