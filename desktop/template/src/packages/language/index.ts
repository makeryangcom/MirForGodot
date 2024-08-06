import {createI18n} from "vue-i18n";
import en from "./en";
import zh from './zh';

const messages = {
    en: en,
    zh: zh
};

function init(){
    let lang: string = "zh";

    if(localStorage.getItem("mir2:language")){
        lang = localStorage.getItem("mir2:language") + ""
    }else{
        localStorage.setItem("mir2:language", "zh")
    }

    return lang
}

export const Language = createI18n({
    legacy: false,
    locale: init(),
    fallbackLocale: "zh",
    messages,
    warnHtmlMessage: false
});