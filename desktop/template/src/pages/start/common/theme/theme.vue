<template>
    <Popover>
        <TooltipProvider>
            <Tooltip>
                <TooltipTrigger as-child>
                    <PopoverTrigger as-child>
                        <Button class="w-8 h-8" variant="ghost" size="icon">
                            <Paintbrush class="w-4 h-4" />
                        </Button>
                    </PopoverTrigger>
                    <PopoverContent :side-offset="13" align="end" class="w-96">
                        <div class="p-2">
                            <div class="grid space-y-1">
                                <h1 class="text-sm text-foreground font-semibold">{{$t("header.theme.title")}}</h1>
                                <p class="text-xs text-muted-foreground">{{$t("header.theme.describe")}}</p>
                            </div>
                            <div class="space-y-1 pt-3">
                                <Label for="color" class="text-xs text-muted-foreground">{{$t("header.theme.colour")}}</Label>
                                <div class="grid grid-cols-3 gap-2 py-1.5">
                                    <Button v-for="(color, index) in props.data.theme.colors" :key="index" variant="outline" class="h-8 justify-start px-3" :class="color === props.data.store.theme ? 'border-foreground border-2' : ''" @click="props.data.store.setTheme(color)">
                                        <span class="h-5 w-5 rounded-full flex items-center justify-center bg-muted" :style="{ backgroundColor: colors[color][7].rgb }">
                                            <CheckIcon v-if="color === props.data.store.theme" class="h-3 w-3 text-white"/>
                                        </span>
                                        <span class="ml-2 text-xs capitalize">{{color}}</span>
                                    </Button>
                                </div>
                            </div>
                            <div class="space-y-1 pt-3">
                                <Label for="radius" class="text-xs text-muted-foreground">{{$t("header.theme.fillet")}}</Label>
                                <div class="grid grid-cols-5 gap-2 py-1.5">
                                    <Button v-for="(r, index) in props.data.store.RADII" :key="index" variant="outline" class="h-8 justify-center px-3" :class="r === props.data.store.radius ? 'border-foreground border-2' : ''" @click="props.data.store.setRadius(r)">
                                        <span class="text-xs">{{ r }}</span>
                                    </Button>
                                </div>
                            </div>
                            <div class="space-y-1 pt-3">
                                <Label for="theme" class="text-xs text-muted-foreground">{{$t("header.theme.style")}}</Label>
                                <div class="flex space-x-2 py-1.5">
                                    <Button class="h-8" variant="outline" :class="{ 'border-2 border-foreground': !props.data.theme.dark }" @click="props.data.theme.dark = false">
                                        <SunIcon class="w-4 h-4 mr-2" />
                                        <span class="text-xs">Light</span>
                                    </Button>
                                    <Button class="h-8" variant="outline" :class="{ 'border-2 border-foreground': props.data.theme.dark }" @click="props.data.theme.dark = true">
                                        <MoonIcon class="w-4 h-4 mr-2" />
                                        <span class="text-xs">Dark</span>
                                    </Button>
                                </div>
                            </div>
                        </div>
                    </PopoverContent>
                </TooltipTrigger>
                <TooltipContent align="center" side="bottom" :align-offset="0" :arrow-padding="0" avoid-collisions :collision-boundary="null" :collision-padding="{}" hide-when-detached sticky="always">{{$t("header.theme.tooltip")}}</TooltipContent>
            </Tooltip>
        </TooltipProvider>
    </Popover>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick, watch} from "vue";
import {colors} from "@/lib/colors";
import {Button} from "@/lib/button";
import {Label} from "@/lib/label";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/lib/tooltip";
import {Popover, PopoverTrigger, PopoverContent} from "@/lib/popover";
import {SunIcon, MoonIcon, CheckIcon} from "@radix-icons/vue";
import {Paintbrush} from "lucide-vue-next";

const props: any = defineProps<{
    data: any
}>();

watch(props.data.store, (theme: any) => {
    document.documentElement.classList.remove(
        ...props.data.theme.colors.map((color: any) => `theme-${color}`),
    );
    document.documentElement.classList.add(`theme-${props.data.store.theme}`);
});

watch(props.data.store, (radius: any) => {
    document.documentElement.style.setProperty("--radius", `${props.data.store.radius}rem`)
});

onBeforeMount(() => {});

onMounted(() => {
    document.documentElement.style.setProperty("--radius", `${props.data.store.radius}rem`);
    document.documentElement.classList.add(`theme-${props.data.store.theme}`);
    nextTick(() => {});
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>