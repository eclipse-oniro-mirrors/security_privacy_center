/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import HeadComponent from '../common/component/headComponent';
import { WidthPercent, LocationChoice, ConfigValue } from '../common/util/ConfigData';
import router from '@ohos.router';
import CmFaPresenter from '../presenter/CmFaPresenter';
import { GlobalContext } from '../common/GlobalContext';
import { RouterFileVo } from '../model/CertManagerVo/RouterInfoVo';

@Entry
@Component
struct CertPwdInput {
  certPwd: string = '';
  @State mFaPresenter: CmFaPresenter = CmFaPresenter.getInstance();

  onPageShow() {
    let uri = GlobalContext.getContext().getAbilityWant().uri;
    GlobalContext.getContext().clearAbilityWantUri();

    if (uri === 'certInstall') {
      router.pushUrl({
        url: 'pages/certInstallFromStorage'
      })
    } else if (uri === 'requestAuthorize') {
      this.mFaPresenter.startRequestAuth(GlobalContext.getContext().getAbilityWant().parameters?.appUid as string);
    }
  }

  build() {
    Column() {
      Column() {
        HeadComponent({ headName: $r('app.string.certificatePwdTab') });
        Text($r('app.string.certificatePwdInfo'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(FontWeight.Medium)
          .margin({
            top: $r('app.float.distance_24'),
            left: $r('app.float.distance_24')
          })
          .alignSelf(ItemAlign.Start);

        TextInput()
          .type(InputType.Password)
          .onChange((value: string) => {
            this.certPwd = value;
          })
          .maxLength(ConfigValue.PWD_MAX_LENGTH)
          .margin({
            top: $r('app.float.distance_16'),
            left: $r('app.float.distance_24'),
            right: $r('app.float.distance_24')
          })
          .height('40vp')
      }
      .width(WidthPercent.WH_100_100)
      .height(WidthPercent.WH_75_100);

      Column() {
        Row() {
          Button() {
            Text($r('app.string.installPwdInputCancel'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.ohos_id_color_text_hyperlink'))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.install_cancel_bt_bg_color'))
          .width($r('app.float.component_button_width_phone'))
          .height($r('app.float.application_button_height'))
          .margin({
            left: $r('app.float.distance_24'),
          })
          .onClick(() => {
            router.back();
          })

          Button() {
            Text($r('app.string.installPwdInputConfirm'))
              .fontSize($r('sys.float.ohos_id_text_size_body1'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.install_confirm_bt_font_color'))
          }
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.install_confirm_bt_bg_color'))
          .width($r('app.float.component_button_width_phone'))
          .height($r('app.float.application_button_height'))
          .margin({
            left: $r('app.float.distance_16'),
            right: $r('app.float.distance_24'),
          })
          .onClick(() => {
            GlobalContext.getContext().getPwdStore().setCertPwd(this.certPwd)
            let fileInfo: RouterFileVo = router.getParams() as RouterFileVo;
            router.pushUrl({
              url: 'pages/certInstallAliasInput',
              params: fileInfo
            })
          })
        }
        .margin({ bottom: $r('app.float.wh_value_24') })
      }
      .justifyContent(FlexAlign.End)
      .height(WidthPercent.WH_25_100);
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(WidthPercent.WH_100_100)
    .height(WidthPercent.WH_100_100);
  }
}
