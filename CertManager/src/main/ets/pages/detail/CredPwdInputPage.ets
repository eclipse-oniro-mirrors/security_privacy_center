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

import HeadComponent from '../../common/component/headComponent';
import { ConfigValue, WidthPercent } from '../../common/util/ConfigData';
import { BusinessError } from '@ohos.base';
import { CMModelErrorCode } from '../../model/CertMangerModel';
import { RouterFileVo } from '../../model/CertManagerVo/RouterInfoVo';
import { GlobalContext } from '../../common/GlobalContext';
import CmInstallPresenter from '../../presenter/CmInstallPresenter';
import { SheetParam } from '../../common/util/SheetParam';
import { NavEntryKey } from '../../common/NavEntryKey';

const TAG: string = 'CredPwdInputPage: ';

export class CredPwdInputParam {
  public credFile: RouterFileVo;

  constructor(file: RouterFileVo) {
    this.credFile = file;
  }
}

@Component
export struct CredPwdInputPage {
  private stack?: NavPathStack;

  private credFile?: RouterFileVo;

  @State private bottomRectHeight: number = 80;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;

  @State certPwd: string = '';
  @State isPasswordError: boolean = false;
  @State passWordWarn: number = 0;
  @Prop sheetParam: SheetParam;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            HeadComponent({ headName: $r('app.string.certificatePwdTab'), isStartBySheet: true, onBackClicked: () => {
              this.stack?.pop();
            } })
              .margin({
                left: $r('app.float.wh_value_12'),
                top: 8
              })
          }.zIndex(1)
          .onAreaChange((oldArea, newArea) => {
            this.headRectHeight = newArea.height as number;
            this.headRectHeightReal = newArea.height as number;
          })

          Stack({ alignContent: Alignment.TopEnd }) {
            Scroll() {
              this.buildContent()
            }
            .align(Alignment.Top)
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Off)
            .edgeEffect(EdgeEffect.Spring)
            .width(WidthPercent.WH_100_100)
            .height(WidthPercent.WH_AUTO)
            .constraintSize({
              minHeight: this.getScrollMinHeight()
            })
          }.padding({
            top: this.headRectHeight
          })
        }
        .width(WidthPercent.WH_100_100)
        .height(WidthPercent.WH_AUTO)
        .padding({
          bottom: this.bottomRectHeight
        })

        Column() {
          Button() {
            Text($r('app.string.installPwdInputConfirm'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.install_confirm_bt_font_color'))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.install_confirm_bt_bg_color'))
          .width(WidthPercent.WH_100_100)
          .height($r('app.float.wh_value_40'))
          .margin({
            top: $r('app.float.distance_16'),
            bottom: $r('app.float.distance_24')
          })
          .enabled(this.certPwd !== undefined && this.certPwd.length > 0)
          .onClick(() => {
            if (this.credFile === undefined || this.credFile === null) {
              console.error(TAG + 'Cred file is undefined');
              return;
            }
            this.isPasswordError = false;
            GlobalContext.getContext().getPwdStore().setCertPwd(this.certPwd);
            CmInstallPresenter.getInstance().installCert(this.credFile.uri, '', this.credFile.suffix, false).then((resultCode) => {
              this.passWordWarn = resultCode;
              console.log(TAG + 'install cred result code = ' + resultCode);
              if (resultCode === CMModelErrorCode.CM_MODEL_ERROR_PASSWORD_ERR) {
                this.isPasswordError = true;
              } else {
                this.stack?.pop();
              }
            });
          })
        }.onAreaChange((oldArea: Area, newArea: Area) => {
          this.bottomRectHeight = newArea.height as number;
        })
        .padding({
          left: 16, right: 16
        })
      }
      .width(WidthPercent.WH_100_100)
      .height(WidthPercent.WH_AUTO)
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .hideTitleBar(true)
    .width(WidthPercent.WH_100_100)
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.CRED_PWD_INPUT_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      try {
        this.credFile = (ctx.pathInfo.param as CredPwdInputParam).credFile;
      } catch (err) {
        let error = err as BusinessError;
        console.error(TAG + 'Get cred file failed: ' + error?.code + ', message: ' + error?.message);
      }
    })
  }

  @Builder
  private buildContent() {
    Column() {
      Text($r('app.string.certificatePwdInfo'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontWeight(FontWeight.Medium)
        .margin({
          top: $r('app.float.distance_24'),
          left: $r('app.float.distance_24')
        })
        .alignSelf(ItemAlign.Start);

      TextInput({ text: this.certPwd })
        .type(InputType.Password)
        .focusable(true)
        .border(this.isPasswordError ? {
          width: $r('app.float.wh_value_1'),
          color: $r('sys.color.ohos_id_color_warning')
        } : { width: $r('app.float.wh_value_0') })
        .maxLength(ConfigValue.PWD_MAX_LENGTH)
        .margin({
          top: $r('app.float.distance_16'),
          left: $r('app.float.distance_24'),
          right: $r('app.float.distance_24')
        })
        .height($r('app.float.wh_value_40'))
        .onChange((value: string) => {
          this.certPwd = value;
        })

      Row() {
        Text($r('app.string.Password_Message'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('app.float.distance_14'))
          .fontWeight(FontWeight.Regular)
          .lineHeight($r('app.float.distance_19'))
          .width(WidthPercent.WH_100_100)
          .textAlign(TextAlign.Center)
          .fontColor($r('sys.color.ohos_id_color_warning'))
          .visibility(this.passWordWarn === CMModelErrorCode.CM_MODEL_ERROR_PASSWORD_ERR
            ? Visibility.Visible : Visibility.None)
      }
    }
    .width(WidthPercent.WH_100_100)
    .alignItems(HorizontalAlign.Start)
  }

  getScrollMinHeight() {
    if (this.sheetParam === undefined || this.headRectHeightReal === 0 ||
      this.sheetParam.sheetMinHeight < (this.headRectHeightReal + this.bottomRectHeight)) {
      return 0;
    }
    return this.sheetParam.sheetMinHeight - this.headRectHeightReal - this.bottomRectHeight;
  }
}