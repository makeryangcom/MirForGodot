import Axios from "axios";
import FingerprintJS from "@fingerprintjs/fingerprintjs";

const request = Axios.create({
    baseURL: "",
    timeout: 15000,
});

request.interceptors.response.use(
    response => {
        if (response.status === 200) {
            return Promise.resolve(response);
        } else {
            return Promise.reject(response);
        }
    },
    error => {
        if(error.response){
            if (error.response.status) {
                return false;
            }
        }
        return false;
    }
);

export async function Request(path: string, method: string, params: object, data: object) {
    const baseURL: string = "https://api.mir2.geekros.com";
    return FingerprintJS.load().then((fp: any) => {
        return fp.get().then((result: any) => {
            return request({
                baseURL: baseURL,
                headers: {
                    "Content-Type": "application/json",
                    "Accept-Fetch-Id": "desktop",
                    "Accept-Fetch-Referer": "makeryang.com",
                    "Accept-Fetch-Visitor": result.visitorId,
                    "Accept-Fetch-Auth": localStorage.getItem("mir2:login:token") ? localStorage.getItem("mir2:login:token") : ""
                },
                url: path,
                method: method,
                params: params ? params : {},
                data: data ? data : {}
            });
        });
    }).catch(()=>{
        return request({
            baseURL: baseURL,
            headers: {
                "Content-Type": "application/json",
                "Accept-Fetch-Id": "desktop",
                "Accept-Fetch-Referer": "makeryang.com",
                "Accept-Fetch-Visitor": "",
                "Accept-Fetch-Auth": ""
            },
            url: path,
            method: method,
            params: params ? params : {},
            data: data ? data : {}
        });
    });
}