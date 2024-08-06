<template>
    <Card class="w-[380px] rounded-md mx-auto">
        <CardHeader>
            <CardTitle class="text-xl">{{$t("page.login.title")}}</CardTitle>
            <CardDescription>{{$t("page.login.describe")}}</CardDescription>
        </CardHeader>
        <CardContent v-if="props.data.page.login.type === 'login'">
            <div class="grid gap-4">
                <form novalidate class="space-y-1" @submit="onSubmit">
                    <FormField v-slot="{componentField}" name="email" :validate-on-blur="!isFieldDirty">
                        <FormItem>
                            <FormLabel>{{$t("page.login.email")}}</FormLabel>
                            <FormControl>
                                <Input id="email" type="email" placeholder="you@example.com" autocomplete="off" spellcheck="false" required v-bind="componentField" />
                            </FormControl>
                            <FormDescription></FormDescription>
                            <FormMessage class="text-xs" />
                        </FormItem>
                    </FormField>
                    <FormField v-slot="{componentField}" name="password" :validate-on-blur="!isFieldDirty">
                        <FormItem>
                            <FormLabel>
                                <div class="flex items-center">
                                    <Label>{{$t("page.login.password")}}</Label>
                                    <span class="ml-auto inline-block text-sm underline  hover:cursor-pointer">{{$t("page.login.forgot_password")}}</span>
                                </div>
                            </FormLabel>
                            <FormControl>
                                <Input id="password" type="password" autocomplete="off" spellcheck="false" required v-bind="componentField" />
                            </FormControl>
                            <FormDescription></FormDescription>
                            <FormMessage class="text-xs" />
                        </FormItem>
                    </FormField>
                    <Button type="submit" class="w-full" :disabled="props.data.page.login.loading">
                        <ReloadIcon class="w-4 h-4 mr-2 animate-spin" v-if="props.data.page.login.loading" />
                        <span>{{$t("page.login.button")}}</span>
                    </Button>
                </form>
            </div>
            <div class="mt-4 text-center text-sm">
                <span class="mr-2">{{$t("page.login.account")}}</span>
                <span class="underline hover:cursor-pointer" @click="onType('register')">{{$t("page.login.register.button")}}</span>
            </div>
        </CardContent>
        <CardContent v-if="props.data.page.login.type === 'register'">
            <div class="grid gap-4">
                <form novalidate class="space-y-1" @submit="onSubmit">
                    <FormField v-slot="{componentField}" name="email" :validate-on-blur="!isFieldDirty">
                        <FormItem>
                            <FormLabel>{{$t("page.login.register.email")}}</FormLabel>
                            <FormControl>
                                <Input id="email" type="email" placeholder="you@example.com" autocomplete="off" spellcheck="false" required v-bind="componentField" />
                            </FormControl>
                            <FormDescription></FormDescription>
                            <FormMessage class="text-xs" />
                        </FormItem>
                    </FormField>
                    <FormField v-slot="{ componentField }" name="code" :validate-on-blur="!isFieldDirty">
                        <FormItem>
                            <FormLabel>{{$t("page.login.register.code.title")}}</FormLabel>
                            <FormControl>
                                <div class="flex w-full max-w-sm items-center gap-1.5">
                                    <Input id="code" type="text" maxlength="6" placeholder="888888" autocomplete="off" spellcheck="false" required v-bind="componentField" />
                                    <Button class="text-xs" type="button" @click="onCodeSubmit" v-if="props.data.page.login.code.loading">
                                        <span v-html="$t('page.login.register.code.loading', {count: props.data.page.login.code.count})"></span>
                                    </Button>
                                    <Button class="text-xs" type="button" @click="onCodeSubmit" v-else>{{$t("page.login.register.code.button")}}</Button>
                                </div>
                            </FormControl>
                            <FormDescription></FormDescription>
                            <FormMessage class="text-xs" />
                        </FormItem>
                    </FormField>
                    <FormField v-slot="{componentField}" name="password" :validate-on-blur="!isFieldDirty">
                        <FormItem>
                            <FormLabel>{{$t("page.login.register.password")}}</FormLabel>
                            <FormControl>
                                <Input id="password" type="password" autocomplete="off" spellcheck="false" required v-bind="componentField" />
                            </FormControl>
                            <FormDescription></FormDescription>
                            <FormMessage class="text-xs" />
                        </FormItem>
                    </FormField>
                    <Button type="submit" class="w-full" :disabled="props.data.page.login.loading">
                        <ReloadIcon class="w-4 h-4 mr-2 animate-spin" v-if="props.data.page.login.loading" />
                        <span>{{$t("page.login.register.button")}}</span>
                    </Button>
                </form>
            </div>
            <div class="mt-4 text-center text-sm">
                <span class="mr-2">{{$t("page.login.register.account")}}</span>
                <span class="underline hover:cursor-pointer" @click="onType('login')">{{$t("page.login.button")}}</span>
            </div>
        </CardContent>
    </Card>
</template>

<script setup lang="ts">
import {onBeforeMount, onMounted, onBeforeUnmount, onUnmounted, nextTick, ref} from "vue";
import {Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle} from "@/lib/card";
import {FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage} from "@/lib/form";
import {Button} from "@/lib/button";
import {Label} from "@/lib/label";
import {Input} from "@/lib/input";
import {ReloadIcon} from "@radix-icons/vue";

const props: any = defineProps<{
    data: any
}>();

const formLogin = props.data.browser.form.schema(props.data.browser.form.object({
    email: props.data.browser.form.string({required_error: props.data.base.lang.t("common.status.20001"), invalid_type_error: props.data.base.lang.t("common.status.20001")}).email({message: props.data.base.lang.t("common.status.20001")}),
    password: props.data.browser.form.string({required_error: props.data.base.lang.t("common.status.20002"), invalid_type_error: props.data.base.lang.t("common.status.20002")}).nonempty({message: props.data.base.lang.t("common.status.20002")})
}));

const formRegister = props.data.browser.form.schema(props.data.browser.form.object({
    email: props.data.browser.form.string({required_error: props.data.base.lang.t("common.status.20001"), invalid_type_error: props.data.base.lang.t("common.status.20001")}).email({message: props.data.base.lang.t("common.status.20001")}),
    code: props.data.browser.form.string({required_error: props.data.base.lang.t("common.status.20005"), invalid_type_error: props.data.base.lang.t("common.status.20005")}).nonempty({message: props.data.base.lang.t("common.status.20005")}).min(6, {message: props.data.base.lang.t("common.status.20005")}).max(6, {message: props.data.base.lang.t("common.status.20005")}),
    password: props.data.browser.form.string({required_error: props.data.base.lang.t("common.status.20002"), invalid_type_error: props.data.base.lang.t("common.status.20002")}).nonempty({message: props.data.base.lang.t("common.status.20002")})
}));

const validationSchema = ref(formLogin);

const {isFieldDirty, handleSubmit, validateField, resetForm, values} = props.data.browser.form.use({
    validationSchema,
});

function onType(type: string){
    if(!props.data.page.login.loading){
        props.data.page.login.type = type;
        if(type == "login"){
            validationSchema.value = formLogin;
        }
        if(type == "register"){
            validationSchema.value = formRegister;
        }
        resetForm();
    }
}

function onCodeSubmit(){
    if(props.data.page.login.type === "register"){
        validateField("email").then((res: any)=>{
            if(!res.valid){
                return;
            }
            if(!props.data.page.login.code.loading){
                props.data.page.login.code.loading = true;
                props.data.browser.request("/desktop/index/mail/code", "GET", {mail: values.email}, {}).then((request: any) => {
                    if(request.status === 200){
                        if (request.data.code === 0) {
                            props.data.page.login.code.timer = setInterval(()=>{
                                props.data.page.login.code.count--;
                                if (props.data.page.login.code.count === 0) {
                                    clearInterval(props.data.page.login.code.timer);
                                    props.data.page.login.code.timer = null;
                                    props.data.page.login.code.count = 60;
                                    props.data.page.login.code.loading = false;
                                }
                            }, 1000);
                        }else{
                            props.data.page.login.code.loading = false;
                            props.data.browser.toast({
                                title: props.data.base.lang.t("common.tooltips"),
                                description: props.data.base.lang.t("common.status." + request.data.message),
                                variant: "warning",
                            });
                        }
                    }else{
                        props.data.page.login.code.loading = false;
                        props.data.browser.toast({
                            title: props.data.base.lang.t("common.tooltips"),
                            description: props.data.base.lang.t("common.abnormal"),
                            variant: "error",
                        });
                    }
                });
            }
        }).catch((res: any)=>{});
    }
}

const onSubmit = handleSubmit((values: any) => {
    if(props.data.page.login.type === "login"){
        if(!props.data.page.login.loading){
            props.data.page.login.loading = true;
            props.data.browser.request("/desktop/index/mail/login", "GET", values, {}).then((request: any) => {
                if(request.status === 200){
                    if (request.data.code === 0) {
                        const data: any = request.data.data;
                        localStorage.setItem("mir2:login:token", data.token);
                        props.data.page.login.loading = false;
                        props.data.base.ipc.send("message", {type: "on:login"});
                    }else{
                        props.data.page.login.loading = false;
                        props.data.browser.toast({
                            title: props.data.base.lang.t("common.tooltips"),
                            description: props.data.base.lang.t("common.status." + request.data.message),
                            variant: "warning",
                        });
                    }
                }else{
                    props.data.page.login.loading = false;
                    props.data.browser.toast({
                        title: props.data.base.lang.t("common.tooltips"),
                        description: props.data.base.lang.t("common.abnormal"),
                        variant: "error",
                    });
                }
            });
        }
    }
    if(props.data.page.login.type === "register"){
        if(!props.data.page.login.loading) {
            props.data.page.login.loading = true;
            props.data.browser.request("/desktop/index/mail/register", "GET", values, {}).then((request: any) => {
                if(request.status === 200){
                    if (request.data.code === 0) {
                        const data: any = request.data.data;
                        localStorage.setItem("mir2:login:token", data.token);
                        props.data.page.login.loading = false;
                        props.data.base.ipc.send("message", {type: "on:login"});
                    }else{
                        props.data.page.login.loading = false;
                        props.data.browser.toast({
                            title: props.data.base.lang.t("common.tooltips"),
                            description: props.data.base.lang.t("common.status." + request.data.message),
                            variant: "warning",
                        });
                    }
                }else{
                    props.data.page.login.loading = false;
                    props.data.browser.toast({
                        title: props.data.base.lang.t("common.tooltips"),
                        description: props.data.base.lang.t("common.abnormal"),
                        variant: "error",
                    });
                }
            });
        }
    }
});

onBeforeMount(() => {});

onMounted(() => {
    nextTick(() => {});
});

onBeforeUnmount(() => {
    if(props.data.page.login.code.timer){
        clearInterval(props.data.page.login.code.timer);
        props.data.page.login.code.timer = null;
        props.data.page.login.code.count = 60;
        props.data.page.login.code.loading = false;
    }
});

onUnmounted(() => {});
</script>