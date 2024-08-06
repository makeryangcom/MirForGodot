<template>
    <div class="sticky h-[60px] z-50000 top-0 bg-background/80 backdrop-blur-lg border-b border-border drag">
        <div class="w-full h-[60px] px-2 grid gap-2 grid-cols-7 items-center ">
            <div class="col-span-2 flex items-center space-x-2">
                <div class="w-8 h-8 text-center">
                    <div class="w-8 h-8">
                        <img class="w-8 h-8" src="/image/icon.png"  alt=""/>
                    </div>
                </div>
            </div>
            <div class="col-span-3 text-center">
                <Tabs class="tabs" v-model:model-value="props.data.page.current" :default-value="props.data.page.current" v-if="props.data.page.current !== '' && props.data.page.current !== 'login'">
                    <TabsList class="list no-drag">
                        <TabsTrigger value="dashboard" >
                            <Compass class="w-4 h-4" />
                            <span class="ml-1">{{$t("header.tab.dashboard")}}</span>
                        </TabsTrigger>
                        <TabsTrigger value="account" >
                            <Users class="w-4 h-4" />
                            <span class="ml-1">{{$t("header.tab.account")}}</span>
                        </TabsTrigger>
                        <TabsTrigger value="assets" >
                            <MixIcon class="w-4 h-4" />
                            <span class="ml-1">{{$t("header.tab.assets")}}</span>
                        </TabsTrigger>
                        <TabsTrigger value="operate" >
                            <BarChartBig class="w-4 h-4" />
                            <span class="ml-1">{{$t("header.tab.operate")}}</span>
                        </TabsTrigger>
                        <TabsTrigger value="tools" >
                            <PencilRuler class="w-4 h-4" />
                            <span class="ml-1">{{$t("header.tab.tools")}}</span>
                        </TabsTrigger>
                    </TabsList>
                </Tabs>
            </div>
            <div class="h-8 col-span-2 flex items-center space-x-3 justify-end">
                <div class="h-8 w-auto space-x-2 no-drag">
                    <TooltipProvider>
                        <Tooltip>
                            <TooltipTrigger as-child>
                                <Button class="w-8 h-8" variant="ghost" size="icon" @click="props.data.header.search.status = true">
                                    <Search class="w-4 h-4" />
                                </Button>
                            </TooltipTrigger>
                            <TooltipContent align="center" side="bottom" :align-offset="0" :arrow-padding="0" avoid-collisions :collision-boundary="null" :collision-padding="{}" hide-when-detached sticky="always">{{$t("header.search.tooltip")}}</TooltipContent>
                        </Tooltip>
                    </TooltipProvider>
                    <HeaderTheme ref="headerTheme" :data="props.data" />
                </div>
                <div class="h-8 w-auto no-drag">
                    <Button class="w-8 h-8" variant="ghost" size="icon" v-if="props.data.page.current === 'login'">
                        <PersonIcon class="w-4 h-4" />
                    </Button>
                    <DropdownMenu v-else>
                        <DropdownMenuTrigger as-child>
                            <Button class="w-8 h-8" variant="ghost" size="icon">
                                <PersonIcon class="w-4 h-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent class="w-auto" align="center" :side-offset="13">
                            <DropdownMenuLabel class="font-normal flex">
                                <div class="flex flex-col space-y-1">
                                    <p class="text-sm font-medium leading-none">{{props.data.service.account.account_nickname}}</p>
                                    <p class="text-xs leading-none text-muted-foreground">{{props.data.service.account.account_mail}}</p>
                                </div>
                            </DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuGroup>
                                <DropdownMenuItem class="hover:cursor-pointer" @click="onSettings('profile')">
                                    <span class="mr-2">{{$t("header.user.profile")}}</span>
                                    <DropdownMenuShortcut>⇧⌘P</DropdownMenuShortcut>
                                </DropdownMenuItem>
                                <DropdownMenuItem class="hover:cursor-pointer" @click="onSettings('user')">
                                    <span class="mr-2">{{$t("header.user.member")}}</span>
                                    <DropdownMenuShortcut>⇧⌘M</DropdownMenuShortcut>
                                </DropdownMenuItem>
                            </DropdownMenuGroup>
                            <DropdownMenuSeparator />
                            <DropdownMenuGroup>
                                <DropdownMenuItem class="hover:cursor-pointer" @click="onSettings('upgrade')">
                                    <Sparkles class="w-4 h-4 mr-2" />
                                    <span class="mr-2">{{$t("header.user.upgrade")}}</span>
                                    <DropdownMenuShortcut>⇧⌘U</DropdownMenuShortcut>
                                </DropdownMenuItem>
                            </DropdownMenuGroup>
                            <DropdownMenuSeparator />
                            <DropdownMenuGroup>
                                <DropdownMenuItem class="hover:cursor-pointer" @click="onSettings('basic')">
                                    <GearIcon class="w-4 h-4 mr-2" />
                                    <span class="mr-2">{{$t("header.user.settings")}}</span>
                                    <DropdownMenuShortcut>⇧⌘S</DropdownMenuShortcut>
                                </DropdownMenuItem>
                            </DropdownMenuGroup>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem class="hover:cursor-pointer" @click="onLogout">
                                <span>{{$t("header.user.logout")}}</span>
                                <DropdownMenuShortcut>⇧⌘Q</DropdownMenuShortcut>
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
                <div class="h-8 w-auto no-drag">
                    <Button class="w-8 h-8" variant="ghost" size="icon" title="最小化" @click="onRightButton('min')">
                        <MinusIcon class="w-4 h-4" />
                    </Button>
                    <Button class="w-8 h-8" variant="ghost" size="icon" :title="!props.data.base.window.max ? '全屏' : '还原'" @click="onRightButton('size')">
                        <BoxIcon class="w-4 h-4" v-if="!props.data.base.window.max" />
                        <RotateCounterClockwiseIcon class="item-icon" v-if="props.data.base.window.max" />
                    </Button>
                    <Button class="w-8 h-8" variant="ghost" size="icon" title="关闭" @click="onRightButton('close')">
                        <Cross1Icon class="w-4 h-4" />
                    </Button>
                </div>
            </div>
        </div>
    </div>
    <Dialog v-model:open="props.data.header.search.status">
        <DialogContent class="p-0 w-[380px]">
            <DialogHeader class="h-0 hidden">
                <DialogTitle></DialogTitle>
                <DialogDescription></DialogDescription>
            </DialogHeader>
            <Command>
                <CommandInput class="h-12" :placeholder="$t('common.search.keyword')" />
                <CommandEmpty class="text-muted-foreground text-sm">{{$t("common.nodata")}}</CommandEmpty>
                <CommandList @escape-key-down="props.data.header.search.status = false">
                    <CommandGroup heading="Links"></CommandGroup>
                </CommandList>
            </Command>
        </DialogContent>
    </Dialog>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick} from "vue";
import HeaderTheme from "./theme/theme.vue";
import {Button} from "@/lib/button";
import {Tabs, TabsList, TabsTrigger} from "@/lib/tabs";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/lib/tooltip";
import {Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription} from "@/lib/dialog";
import {Command, CommandInput, CommandEmpty, CommandList, CommandGroup, CommandItem, CommandSeparator} from "@/lib/command";
import {DropdownMenu, DropdownMenuContent, DropdownMenuGroup, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuShortcut, DropdownMenuTrigger} from "@/lib/dropdown-menu";
import {MinusIcon, RotateCounterClockwiseIcon, BoxIcon, Cross1Icon} from "@radix-icons/vue";
import {PersonIcon, GearIcon, MixIcon} from "@radix-icons/vue";
import {Search, Sparkles, Compass, Users, PencilRuler, BarChartBig} from "lucide-vue-next";

const props: any = defineProps<{
    data: any
}>();

props.data.base.ipc.on("message", (event: any, message: any) => {
    if(message.type === "header:right:button"){
        props.data.base.window.max = (message.data !== "restore");
    }
});

function onHeaderTab(tab: string){

}

function onSettings(nav: string){

}

function onRightButton(data: string){
    props.data.base.ipc.send("message", {type: "header:right:button", data: data});
}

function onLogout(){
    localStorage.removeItem("mir2:login:token");
    props.data.base.ipc.send("message", {type: "on:login"});
}

onBeforeMount(() => {});

onMounted(() => {
    nextTick(() => {});
});

onBeforeUnmount(() => {});

onUnmounted(() => {});
</script>