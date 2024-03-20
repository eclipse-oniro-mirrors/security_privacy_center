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

import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@ohos.base';
import { StringUtil } from './StringUtil';
import Logger from './Logger';
import HiSysEventConstant from '../constants/HiSysEventConstant';
import GetSelfBundleInfoUtils from './GetSelfBundleInfoUtils';

const TAG = 'HiSysEventUtil';

export default class HiSysEventUtil {
  private constructor() {
  }

  /**
   * 湖内应用跳转更多权限页面时的点击事件
   *
   * @params bundleName 湖内应用包名
   * @params appVersion 湖内应用版本号
   * @returns Promise<void>
   */
  static async reportAppPermJumpMorePerm(bundleName: string, appVersion: string): Promise<void> {
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'BUNDLE_NAME': bundleName,
      'APP_VERSION': appVersion,
    };

    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, HiSysEventConstant.APP_PAGE_MORE_EVENT_NAME,
      hiSysEvent.EventType.BEHAVIOR, eventParams);
  }

  /**
   * 复杂权限组[位置信息-精确位置]跳转到二级页面操作权限状态时的点击事件
   *
   * @params bundleName 应用包名
   * @params appVersion 应用版本号
   * @returns Promise<void>
   */
  static async reportAppPermissionJumpPage(bundleName: string, appVersion: string, operationPermissionGroup: string): Promise<void> {
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'BUNDLE_NAME': bundleName,
      'APP_VERSION': appVersion,
      'OPERATION': operationPermissionGroup
    };
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, HiSysEventConstant.APP_PAGE_EVENT_NAME, hiSysEvent.EventType.BEHAVIOR, eventParams)
  }

  static reportUpdateAppPermissionGroupState(bundleName: string, appVersion: string, permissionGroup: string,
                                             newCheckedState: string, newFlagMask: number, newFlagValue: number): Promise<void> {
    return HiSysEventUtil.reportUpdatePermissionGroupState(HiSysEventConstant.APP_PAGE_PERMISSION_EVENT_NAME, bundleName,
      appVersion, permissionGroup, newCheckedState, newFlagMask, newFlagValue);
  }

  private static async reportUpdatePermissionGroupState(eventName: string, bundleName: string, appVersion: string,
                                                        permissionGroup: string, newCheckedState: string,
                                                        newFlagMask: number, newFlagValue: number): Promise<void> {
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'BUNDLE_NAME': bundleName,
      'APP_VERSION': appVersion,
      'PERMISSION_GROUP': permissionGroup,
      'NEW_CHECKED_STATE': newCheckedState,
      'NEW_FLAG_MASK': newFlagMask,
      'NEW_FLAG_VALUE': newFlagValue,
    };
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, eventName, hiSysEvent.EventType.BEHAVIOR, eventParams);
  }

  /**
   * 接入框架接入应用点击事件打点
   *
   * @params { clickedBundleName } 所点击的应用包名
   */
  static async reportAccessClick(clickedBundleName: string): Promise<void> {
    Logger.info(TAG,"reportAccessClick start.")
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'CLICK_ITEM': clickedBundleName,
    };
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, HiSysEventConstant.ACCESS_CLICK_EVENT_NAME, hiSysEvent.EventType.BEHAVIOR, eventParams);
  }

  /**
   *  访问我的位置信息点击打点事件
   */
  static async reportLocationClick(clickedBundleName: string, checkedState: number) {
    if (StringUtil.isEmpty(clickedBundleName)) {
      Logger.info(TAG, 'clickedBundleName is empty');
      return
    }
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'CLICK_ITEM': checkedState,
    };
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, HiSysEventConstant.ACCESS_CLICK_EVENT_NAME, hiSysEvent.EventType.BEHAVIOR, eventParams);
  }

  /**
   * Report data privacy center user click event
   *
   * @param clickItem click item info
   */
  static async reportDataPrivacyClick(clickItem: string): Promise<void> {
    if (StringUtil.isEmpty(clickItem)) {
      Logger.info(TAG, 'clickItem is empty');
      return;
    }
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    let eventParams: Record<string, string | number> = {
      'PNAMEID': HiSysEventConstant.BUNDLE_NAME,
      'PVERSIONID': versionName,
      'CLICK_ITEM': clickItem,
    };
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, HiSysEventConstant.DATA_PRIVACY_CLICK_EVENT_NAME, hiSysEvent.EventType.BEHAVIOR, eventParams)
  }

  /**
   * 界面点击操作打点
   *
   * @param eventName 事件名
   * @param params 参数
   */
  static async reportClick(eventName: string, params: Record<string, string | number>): Promise<void> {
    let versionName: string = await GetSelfBundleInfoUtils.getVersionName();
    params['PNAMEID'] = HiSysEventConstant.BUNDLE_NAME;
    params['PVERSIONID'] = versionName;
    let eventParams: Record<string, string | number> = params;
    HiSysEventUtil.report(HiSysEventConstant.EVENT_DOMAIN, eventName, hiSysEvent.EventType.BEHAVIOR, eventParams)
  }

  private static report(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object): void {
    Logger.info(TAG, `start to report domain: ${domain},eventName: ${name},eventType: ${eventType}, reportData: ${params}`)
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain,
      name: name,
      eventType: eventType,
      params: params
    };
    hiSysEvent.write(sysEventInfo).then(
      () => {
        Logger.info(TAG, `HiSysEventUtil reportHiSysEvent ${sysEventInfo.name} success.`)
      }
    ).catch(
      (err: BusinessError) => {
        Logger.error(TAG, `error code: ${err.code}, error msg: ${err.message}`)
      }
    )
  }
}
