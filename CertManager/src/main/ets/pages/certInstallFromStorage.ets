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

import { WidthPercent } from '../common/util/ConfigData';
import HeadComponent from '../common/component/headComponent';
import CmFaPresenter from '../presenter/CmFaPresenter';
import { GlobalContext } from '../common/GlobalContext';
import ComponentConfig from '../common/component/ComponentConfig';
import router from '@ohos.router';
import { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import checkUserAuthModel from '../model/CheckUserAuthModel';
import { NavEntryKey } from '../common/NavEntryKey';
import picker from '@ohos.file.picker';
import FileIoModel from '../model/FileIoModel';
import CmInstallPresenter from '../presenter/CmInstallPresenter';
import { BusinessError } from '@ohos.base';
import { RouterFileVo } from '../model/CertManagerVo/RouterInfoVo';
import { CredPwdInputParam } from './detail/CredPwdInputPage';
import { SheetParam } from '../common/util/SheetParam';
import FilterParams from '../common/constants/FileFilterParams';

const COPIES_NUM: number = 12;

const TAG: string = 'CertInstallFromStorage: ';

@Entry
@Component
export struct CertInstallFromStorage {
  @State columnMargin: string = '12vp';
  @State mFaPresenter: CmFaPresenter = CmFaPresenter.getInstance();
  @State installCertFlag: boolean = false;
  private context: Context = getContext(this);

  isStartBySheetFirst: boolean = false;
  isStartBySheet: boolean = false;
  selected?: (path: string, param?: Object) => void;
  @Prop sheetParam: SheetParam;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;
  private scroller: Scroller = new Scroller();
  @State private scrollerHeight: number = 0;

  @Styles normalStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
  };
  @Styles pressedStyle() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
  };

  rootCertificateDialog: CustomDialogController = new CustomDialogController({
    alignment: DialogAlignment.Center,
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.rootCertificateContent();
      },
      contentAreaPadding: { right: $r('app.float.wh_value_0') },
      buttons: [
        {
          value: $r('app.string.root_certificate_cancel'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
          }
        },
        {
          value: $r('app.string.root_certificate_continue'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.installCertFlag = true;
            this.checkUserAuth();
          }
        }
      ]
    })
  })

  @Builder
  rootCertificateContent(): void {
    Column() {
      Text($r('app.string.root_certificate'))
        .height($r('app.float.wh_value_56'))
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .margin({
          left: $r('app.float.wh_value_24'),
          right: $r('app.float.wh_value_24')
        })
        .alignSelf(ItemAlign.Start)

      Text($r('app.string.root_certificate_message'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('sys.color.ohos_id_color_primary'))
        .margin({
          left: $r('app.float.wh_value_24'),
          right: $r('app.float.wh_value_24')
        })
        .alignSelf(ItemAlign.Start)
    }
    .width(WidthPercent.WH_100_100)
    .borderRadius($r('app.float.user_list_divider_borderRadius_value'))
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
  }

  checkUserAuth() {
    let titleStr = getContext().resourceManager.getStringSync($r('app.string.Identity_Authentication'));
    checkUserAuthModel.auth(titleStr, (authResult: boolean) => {
      if (authResult) {
        console.info('checkUserAuth success');
        if (this.installCertFlag) {
          if (this.isStartBySheet) {
            this.startInstallCertBySheet();
          } else {
            this.mFaPresenter.startInstallCert(this.context);
          }
        } else {
          if (this.isStartBySheet) {
            this.startInstallEvidenceBySheet();
          } else {
            this.mFaPresenter.startInstallEvidence(this.context);
          }
        }
      }
    })
  }

  startInstallCertBySheet(): void {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = FilterParams.MAX_SELECT_FILE_NUM;
      documentSelectOptions.fileSuffixFilters = FilterParams.CERT_FILE_SUFFIX;
      let documentPicker = new picker.DocumentViewPicker(this.context);
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallCert(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  routeToNextInstallCert(fileUri: string): void {
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.debug(TAG, 'suffix = ', suffix);
        if ((suffix === 'cer') || (suffix === 'pem') || (suffix === 'crt') || (suffix === 'der')) {
          CmInstallPresenter.getInstance().installCert(fileUri, '', suffix, false);
        } else {
          this.mFaPresenter.unrecognizedFileTips();
        }
      }
    })
  }

  startInstallEvidenceBySheet(): void {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = FilterParams.MAX_SELECT_FILE_NUM;
      documentSelectOptions.fileSuffixFilters = FilterParams.CREDENTIAL_FILE_SUFFIX;
      let documentPicker = new picker.DocumentViewPicker(this.context);
      console.info(TAG + 'start documentPicker.select');
      documentPicker.select(documentSelectOptions).then((documentSelectResult) => {
        if (documentSelectResult.length >= 1) {
          this.routeToNextInstallEvidence(String(documentSelectResult[0]))
        } else {
          console.error(TAG + 'documentPicker.select length invalid:' + documentSelectResult.length);
        }
      }).catch((err: BusinessError) => {
        console.error(TAG + 'documentPicker.select failed with err, message: ' + err.message + ', code: ' + err.code);
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      console.error(TAG + 'DocumentViewPicker failed with err, message: ' + e.message + ', code: ' + e.code);
    }
  }

  routeToNextInstallEvidence(fileUri: string): void {
    FileIoModel.getMediaFileSuffix(fileUri, (suffix: string | undefined) => {
      if (suffix !== undefined) {
        console.debug(TAG, 'suffix = ', suffix);
        if ((suffix === 'p12') || (suffix === 'pfx')) {
          this.selected?.(NavEntryKey.CRED_PWD_INPUT_ENTRY, new CredPwdInputParam(new RouterFileVo(fileUri, suffix)));
        } else {
          this.mFaPresenter.unrecognizedFileTips();
        }
      }
    })
  }

  build() {
    Column() {
      GridRow({
        columns: COPIES_NUM,
        gutter: vp2px(1) === 2 ? $r('app.float.wh_value_12') : $r('app.float.wh_value_0')
      }) {
        GridCol({ span: COPIES_NUM }) {
          Row({}) {
            Stack({ alignContent: Alignment.Top }) {
              Column() {
                HeadComponent({ headName: $r('app.string.installInStorageDevice'), isStartBySheet: this.isStartBySheet,
                  icBackIsVisibility: !this.isStartBySheetFirst,
                  onBackClicked: () => {
                    this.selected?.(NavEntryKey.POP);
                  }})
                  .margin({
                    top: this.isStartBySheet ? 8 : 0,
                    left: 12,
                    right: 12
                  })
              }.zIndex(1)
              .onAreaChange((oldArea, newArea) => {
                this.headRectHeight = newArea.height as number;
                this.headRectHeightReal = newArea.height as number;
              })

              Stack({ alignContent: Alignment.TopEnd }) {
                Scroll(this.scroller) {
                  Column() {
                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Text($r('app.string.CA_cert'))
                          .fontSize($r('sys.float.ohos_id_text_size_body1'))
                          .fontColor($r('sys.color.ohos_id_color_text_primary'))
                          .fontWeight(FontWeight.Medium)
                          .margin({ left: $r('app.float.wh_value_12') })
                          .textAlign(TextAlign.Start)
                      }
                    }
                    .stateStyles({
                      normal: this.normalStyle,
                      pressed: this.pressedStyle
                    })
                    .constraintSize({
                      minHeight: $r('app.float.wh_value_48')
                    })
                    .onClick(() => {
                      this.rootCertificateDialog.open();
                    })

                    Divider()
                      .color($r('sys.color.ohos_id_color_list_separator'))
                      .margin({
                        left: $r('app.float.wh_value_12'),
                        right: $r('app.float.wh_value_12')
                      })

                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Text($r('app.string.system_credentials'))
                          .fontSize($r('sys.float.ohos_id_text_size_body1'))
                          .fontColor($r('sys.color.ohos_id_color_text_primary'))
                          .fontWeight(FontWeight.Medium)
                          .margin({ left: $r('app.float.wh_value_12') })
                          .textAlign(TextAlign.Start)
                      }
                      .onClick(() => {
                        this.installCertFlag = false;
                        AppStorage.setOrCreate('installSystemCred', true);
                        AppStorage.setOrCreate('installUserCred',false);
                        if (this.isStartBySheet) {
                          this.startInstallEvidenceBySheet();
                        } else {
                          this.mFaPresenter.startInstallEvidence(this.context);
                        }
                      })
                    }
                    .stateStyles({
                      normal: this.normalStyle,
                      pressed: this.pressedStyle
                    })
                    .constraintSize({
                      minHeight: $r('app.float.wh_value_48')
                    })

                    Divider()
                      .color($r('sys.color.ohos_id_color_list_separator'))
                      .margin({
                        left: $r('app.float.wh_value_12'),
                        right: $r('app.float.wh_value_12')
                      })

                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                        Text($r('app.string.user_certificate_credentials'))
                          .fontSize($r('sys.float.ohos_id_text_size_body1'))
                          .fontColor($r('sys.color.ohos_id_color_text_primary'))
                          .fontWeight(FontWeight.Medium)
                          .margin({ left: $r('app.float.wh_value_12') })
                          .textAlign(TextAlign.Start)
                      }
                      .onClick(() => {
                        this.installCertFlag = false;
                        AppStorage.setOrCreate('installUserCred', true);
                        AppStorage.setOrCreate('installSystemCred',false);
                        if (this.isStartBySheet) {
                          this.startInstallEvidenceBySheet();
                        } else {
                          this.mFaPresenter.startInstallEvidence(this.context);
                        }
                      })
                    }
                    .stateStyles({
                      normal: this.normalStyle,
                      pressed: this.pressedStyle
                    })
                    .constraintSize({
                      minHeight: $r('app.float.wh_value_48')
                    })
                  }
                  .padding($r('app.float.wh_value_4'))
                  .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
                  .borderRadius($r('app.float.radius_20'))
                  .width(ComponentConfig.WH_100_100)
                }
                .align(Alignment.Top)
                .scrollable(ScrollDirection.Vertical)
                .scrollBar(BarState.Off)
                .width(WidthPercent.WH_100_100)
                .edgeEffect(EdgeEffect.Spring)
                .height(this.isStartBySheet ? WidthPercent.WH_AUTO : WidthPercent.WH_100_100)
                .padding({
                  left: 16,
                  right: 16,
                  bottom: $r('app.float.wh_value_24')
                }).constraintSize({
                  minHeight: this.getScrollMinHeight()
                }).onAreaChange((oldArea, newArea) => {
                  this.scrollerHeight = newArea.height as number;
                })

                Column() {
                  ScrollBar({
                    scroller: this.scroller,
                    direction: ScrollBarDirection.Vertical,
                    state: BarState.Auto
                  }).margin({
                    bottom: $r('app.float.wh_value_24')
                  })
                }.height(this.scrollerHeight)
              }.padding({
                top: this.headRectHeight
              })
            }
            .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
            .width(WidthPercent.WH_100_100)
            .height(this.isStartBySheet ? WidthPercent.WH_AUTO : WidthPercent.WH_100_100)
          }
          .width(WidthPercent.WH_100_100)
          .height(this.isStartBySheet ? WidthPercent.WH_AUTO : WidthPercent.WH_100_100);
        }
      }
      .width(WidthPercent.WH_100_100)
      .height(this.isStartBySheet ? WidthPercent.WH_AUTO : WidthPercent.WH_100_100);
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(WidthPercent.WH_100_100)
    .height(this.isStartBySheet ? WidthPercent.WH_AUTO : WidthPercent.WH_100_100);
  }

  getScrollMinHeight() {
    if (this.sheetParam === undefined || this.headRectHeightReal === 0 ||
      this.sheetParam.sheetMinHeight < this.headRectHeightReal) {
      return 0;
    }
    return this.sheetParam.sheetMinHeight - this.headRectHeightReal;
  }

  onPageShow() {
    let uiExtensionFlag = GlobalContext.getContext().getFlag();
    let installType: string = GlobalContext.getContext().getAbilityWant().parameters?.installType as string;
    let uri = GlobalContext.getContext().getAbilityWant().uri ||
      GlobalContext.getContext().getAbilityWant().parameters?.uri;
    GlobalContext.getContext().clearAbilityWantUri();
    GlobalContext.getContext().clearAbilityWantParamsUri();
    if (uri === 'certInstall') {
      router.pushUrl({
        url: 'pages/certInstallFromStorage'
      })
    } else if (uri === 'requestAuthorize') {
      this.mFaPresenter.startRequestAuth(GlobalContext.getContext().getAbilityWant().parameters?.appUid as string);
    } else if (uiExtensionFlag && uri === 'systemCredInstall' && installType === 'systemCred') {
      AppStorage.setOrCreate('installSystemCred', true);
      AppStorage.setOrCreate('installUserCred', false);
      this.mFaPresenter.startInstallEvidence(this.context);
    } else if (uiExtensionFlag && uri === 'specifyInstall') {
      let fileUri = GlobalContext.getContext().getAbilityWant().parameters?.fileUri as string;
      this.mFaPresenter.startInstall(installType, fileUri);
    } else {
      console.error('The want type is not supported');
    }
  }
}