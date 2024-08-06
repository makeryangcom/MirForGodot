<template>
    <div class="w-auto text-sm shadow-sm">
        <NodeToolbar align="end" offset="5" :is-visible="props.data.toolbarVisible" :position="Position.Top">
            <Button class="w-8 h-8 bg-background" variant="secondary" size="icon">
                <DotsVerticalIcon class="w-3 h-3" />
            </Button>
        </NodeToolbar>
        <ContextMenu>
            <ContextMenuTrigger>
                <div class="w-auto h-auto p-3 rounded-md space-y-3">
                    <div class="w-full flex space-x-2 items-center text-xs">
                        <div class="w-6 h-6">
                            <Button class="w-6 h-6 text-xs" size="icon">
                                <PlayIcon class="w-3 h-3" />
                            </Button>
                        </div>
                        <div class="w-[120px] line-clamp-1">{{props.data.label}}</div>
                    </div>
                    <div class="relative min-h-6 flex items-center">
                        <div class="w-full"></div>
                        <Handle id="a" type="target" :position="Position.Right"></Handle>
                    </div>
                </div>
            </ContextMenuTrigger>
            <ContextMenuContent class="hidden"></ContextMenuContent>
        </ContextMenu>
    </div>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick} from "vue";
import {Handle, Position} from "@vue-flow/core";
import {NodeToolbar} from "@vue-flow/node-toolbar";
import {Button} from "@/lib/button";
import {DotsVerticalIcon, PlayIcon} from "@radix-icons/vue";
import {ContextMenu, ContextMenuContent, ContextMenuTrigger} from "@/lib/context-menu";

const props = defineProps({
    id: {
        type: String,
        required: true,
    },
    data: {
        type: Object,
        required: true,
    }
});

onBeforeMount(() => {});

onMounted(() => {
    nextTick(() => {

    });
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>