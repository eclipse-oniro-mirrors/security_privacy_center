/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CustomContentDialog, AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { CMModelErrorCode, CMModelOptType } from '../model/CertMangerModel';
import checkUserAuthModel from '../model/CheckUserAuthModel';
import { BusinessError } from '@ohos.base';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import certManagerModel from '../model/CertMangerModel';
import util from '@ohos.util';

/* instrument ignore file */

const TAG = 'CertificateInstallPage';
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct CertificateInstallPage {
  @State installFailedDialogMessage: ResourceStr = '';
  @State callerName: string = '';
  @State resultCode: number = CMModelErrorCode.CM_MODEL_ERROR_FAILED;
  @State successUri: string = '';
  ;
  private session: UIExtensionContentSession =
    storage?.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private want: Want = storage?.get<Want>('want') as Want;

  private context: Context = getContext(this);

  installFailedDialog: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    showInSubWindow: true,
    cancel: () => {
      this.session?.terminateSelfWithResult({
        resultCode: this.resultCode
      });
    },
    builder: AlertDialog({
      primaryTitle: $r('app.string.cert_install_failed'),
      content: this.installFailedDialogMessage,
      primaryButton: {
        value: $r('app.string.OK'),
        action: () => {
          this.session?.terminateSelfWithResult({
            resultCode: this.resultCode
          });
        }
      }
    })
  });

  installSuccessDialog: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    showInSubWindow: true,
    cancel: () => {
      this.session?.sendData({'uri': this.successUri});
    },
    builder: AlertDialog({
      primaryTitle: $r('app.string.cert_install_success'),
      content: $r('app.string.cert_install_success_tip'),
      primaryButton: {
        value: $r('app.string.OK'),
        action: () => {
          this.session?.sendData({'uri': this.successUri});
        }
      }
    })
  });

  rootCertificateDialog: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    showInSubWindow: false,
    cancel: () => {
      this.session?.terminateSelf();
    },
    builder: AlertDialog({
      primaryTitle: $r('app.string.cert_install_tip', this.callerName),
      content: $r('app.string.cert_install_warning'),
      primaryButton: {
        value: $r('app.string.root_certificate_cancel'),
        action: () => {
          console.info(TAG, 'USER_CA_STATUS_CONFIRM cancel');
          this.session?.terminateSelf();
        }
      },
      secondaryButton: {
        value: $r('app.string.root_certificate_continue'),
        action: () => {
          console.info(TAG, 'USER_CA_STATUS_CONFIRM confirm');
          this.checkUserAuth();
        }
      }
    }),
  })

  aboutToAppear(): void {
    let isGranted = this.getCallerName();
    if (!isGranted) {
      this.session?.terminateSelf();
      return;
    }
    this.rootCertificateDialog.open();
  }

  build() {
  }

  private getCallerName(): boolean {
    if (this.want === undefined || this.want === null) {
      console.error(TAG, 'initData, want is undefined');
      return false;
    }
    let parameters = this.want.parameters;
    if (parameters === undefined || parameters === null) {
      console.error(TAG, 'initData, parameters is undefined');
      return false;
    }
    let callerName = parameters['bundleName'];
    if (callerName === undefined || callerName === null) {
      console.error(TAG, 'getCallerName, callerName is undefined');
      return false;
    }
    this.callerName = 'callerName as string';
    return true;
  }

  private handleInstallResult(resultCode: CMModelErrorCode, uri: string) {
    if (resultCode === CMModelErrorCode.CM_MODEL_ERROR_SUCCESS) {
      this.successUri = uri;
      this.installSuccessDialog.open();
    } else if (resultCode === CMModelErrorCode.CM_MODEL_ERROR_INCORRECT_FORMAT) {
      this.resultCode = CMModelErrorCode.CM_MODEL_ERROR_INCORRECT_FORMAT;
      this.installFailedDialogMessage = $r('app.string.Install_ERROR_INCORRECT_FORMAT');
      this.installFailedDialog.open();
    } else if (resultCode === CMModelErrorCode.CM_MODEL_ERROR_MAX_QUANTITY_REACHED) {
      this.resultCode = CMModelErrorCode.CM_MODEL_ERROR_MAX_QUANTITY_REACHED;
      this.installFailedDialogMessage = $r('app.string.Install_Error_MAX_QUANTITY_REACHED');
      this.installFailedDialog.open();
    } else {
      console.debug(TAG, `result code ${resultCode}, need not show result`);
      this.session?.terminateSelfWithResult({
        resultCode: resultCode
      });
    }
  }

  checkUserAuth() {
    let titleStr = this.context?.resourceManager.getStringSync($r('app.string.Identity_Authentication'));
    checkUserAuthModel.auth(titleStr, (authResult: boolean) => {
      if (!authResult) {
        console.warn(TAG, 'userAuth cancel!');
        this.session?.terminateSelf();
        return;
      }
      console.info(TAG, 'userAuth success!');
      this.installCaCertificate();
    })
  }

  private async getCertificateData(parameters: Record<string, Object>): Promise<Uint8Array | undefined> {
    return new Promise<Uint8Array | undefined>(resolve => {
      let certificateDataObj = parameters['cert'];
      if (certificateDataObj === undefined || certificateDataObj === null) {
        console.error(TAG, 'getCertificateData, certificate data is undefined');
        return resolve(undefined);
      }
      new util.Base64Helper().decode(certificateDataObj as string).then((value) => {
        return resolve(value);
      }).catch((error: BusinessError) => {
        console.error(TAG, `decode certificate data err: ${error?.code}, msg: ${error?.message}`);
        return resolve(undefined);
      });
    });
  }

  private installCaCertificate(): void {
    if (this.want === undefined || this.want === null) {
      console.error(TAG, 'initData, want is undefined');
      return;
    }
    let parameters = this.want.parameters;
    if (parameters === undefined || parameters === null) {
      console.error(TAG, 'initData, parameters is undefined');
      return;
    }
    this.getCertificateData(parameters).then(data => {
      if (data === undefined) {
        console.error(TAG, 'installCaCertificate, certificate data is undefined');
        this.session?.terminateSelf();
        return;
      }
      certManagerModel.installCertOrCred(CMModelOptType.CM_MODEL_OPT_USER_CA, '', data,
        '', (resultCode: CMModelErrorCode, uri: string) => {
          console.info(TAG, `installCertOrCred result: ${resultCode}`);
          this.handleInstallResult(resultCode, uri);
        });
    })
  }
}