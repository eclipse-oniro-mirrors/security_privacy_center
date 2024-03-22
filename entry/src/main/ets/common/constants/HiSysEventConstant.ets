/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export default class HiSysEventConstant {
  static BUNDLE_NAME = 'com.ohos.security_privacy_center';
  static EVENT_DOMAIN = 'PRIVACY_UE';
  static ACCESS_CLICK_EVENT_NAME = 'SECU_PRIV_ENTRANCE';
  static APP_PAGE_PERMISSION_EVENT_NAME = 'APP_PAGE_PERMISSION';
  static APP_PAGE_EVENT_NAME = 'APP_PAGE';
  static APP_PAGE_MORE_EVENT_NAME = 'APP_PAGE_MORE';
  static DATA_PRIVACY_CLICK_EVENT_NAME = 'SECU_DATA_PRIV_ITEM';
  static MAIN_ADVICE_EVENT_NAME = 'MAIN_ADVICE'; //设置-隐私与安全-保护建议打点事件
  static MAIN_BAR_CHART_EVENT_NAME = 'MAIN_BAR_CHART'; //设置-隐私与安全-隐私权限卡片切换打点事件
  static MAIN_BAR_CHART_ITEM_EVENT_NAME = 'MAIN_BAR_CHART_ITEM'; //设置-隐私与安全-点击柱状图应用打点事件
  static MAIN_PERMISSION_LIST_EVENT_NAME = 'MAIN_PERMISSION_LIST'; // 设置-隐私与安全-隐私权限列表打点事件
  static MAIN_PERMISSION_LIST_MORE_EVENT_NAME = 'MAIN_PERMISSION_LIST_MORE'; // 设置-隐私与安全-隐私权限列表点击更多打点事件
  static PERMISSION_PAGE_SEARCH_EVENT_NAME = 'PERMISSION_PAGE_SEARCH'; //设置-隐私与安全-权限-搜索打点事件
  static PERMISSION_PAGE_ACCURACY_EVENT_NAME = 'PERMISSION_PAGE_ACCURACY'; //设置-隐私与安全-权限-位置提高精确度打点事件
  static PERMISSION_PAGE_LOCATION_EVENT_NAME = 'PERMISSION_PAGE_LOCATION'; //设置-隐私与安全-权限-访问我的位置信息开关
  static PERMISSION_PAGE_RECORD_EVENT_NAME = 'PERMISSION_PAGE_RECORD'; //设置-隐私与安全-权限-访问记录打点事件
  static PERMISSION_PAGE_OAID_EVENT_NAME = 'PERMISSION_PAGE_OAID'; //设置-隐私与安全-权限-广告标识
  static PERMISSION_PAGE_SYSTEM_SERVICES_EVENT_NAME = 'PERMISSION_PAGE_SYSTEM_SERVICES'; //设置-隐私与安全-权限-系统服务
  static PERMISSION_PAGE_APP_LIST_EVENT_NAME = 'PERMISSION_PAGE_APP_LIST'; //设置-隐私与安全-权限管理-应用列表打点事件  //最近访问记录
  static RECORD_PAGE_APP_LIST_EVENT_NAME = 'RECORD_PAGE_APP_LIST';//设置-隐私与安全-权限维度访问记录打点事件
  static PORTRAIT_PERMISSION_EVENT_NAME = 'PORTRAIT_PERMISSION';//设置-隐私与安全-应用画像-应用权限管理打点事件
}