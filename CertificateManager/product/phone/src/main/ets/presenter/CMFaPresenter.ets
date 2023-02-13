/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@system.router';
import certManagerModel from '../model/CertMangerModel'
import FileIoModel from '../model/FileIoModel'
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

const TAG = "CMFaPresenter: ";
const PAGE_URI_PWD_INPUT = 'pages/certPwdInput';
const PAGE_URI_ALIAS_INPUT = 'pages/certInstallAliasInput';

export default class CMFaPresenter {
  private static sInstance: CMFaPresenter;

  public static getInstance(): CMFaPresenter {
    if (CMFaPresenter.sInstance == null) {
      CMFaPresenter.sInstance = new CMFaPresenter();
    }
    return CMFaPresenter.sInstance;
  }

  onAboutToAppear() {

  }

  aboutToDisappear() {
  }

  routeToNext(fileUri: string) {
    console.info(TAG + 'routeToNext fileUri: ' + fileUri);
    FileIoModel.getMediaFileSuffix(fileUri, (suffix) => {
      if (suffix) {
        if ((suffix == "cer") || (suffix == "pem")) {
          router.push({
            uri: PAGE_URI_ALIAS_INPUT,
            params: {
              uri: fileUri,
              suffix: suffix
            }
          });
        } else {
          router.push({
            uri: PAGE_URI_PWD_INPUT,
            params: {
              uri: fileUri,
              suffix: suffix
            }
          });
        }
      }
    })
  }

  requestPermissions() {
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(globalThis.certManagerAbilityContext,
      ["ohos.permission.READ_MEDIA"], (data) => {
      console.log("requestPermissions finish");
      this.startInstall();
    })
  }

  startInstall() {
    globalThis.certManagerAbilityContext.startAbilityForResult(
      {
        bundleName: "com.ohos.filepicker",
        abilityName: "MainAbility",
        parameters: {
          'startMode': 'choose',
        }
      },
      {
        windowMode: 102
      }
    )
      .then((data) => {
        if (!data.resultCode) {
          this.routeToNext(data.want.parameters.result)
        }
      })
      .catch((error) => {
        console.log(TAG + 'start filePicker err: ' + error);
      })
  }

  startRequestAuth(uri) {
    router.replace({
      uri: "pages/requestAuth", params: {
        appUid: uri,
      }
    })
  }

  uninstallAllCert() {
    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, (errCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA success');
      } else {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_USER_CA failed');
      }
    });

    certManagerModel.delAllCertOrCred(CMModelOptType.CM_MODEL_OPT_APP_CRED, (errCode) => {
      if (errCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED success');
      } else {
        console.log(TAG + 'uninstallAllCert CM_MODEL_OPT_APP_CRED failed');
      }
    });
  }
}