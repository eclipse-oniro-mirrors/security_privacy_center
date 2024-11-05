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
import { WidthPercent } from '../../common/util/ConfigData';
import { AppAuthorVo } from '../../model/CertManagerVo/AppAuthorVo';
import CmShowAppCredPresenter from '../../presenter/CmShowAppCredPresenter';
import { BusinessError } from '@ohos.base';
import { SheetParam } from '../../common/util/SheetParam';
import { NavEntryKey } from '../../common/NavEntryKey';

const TAG: string = 'AuthorizedAppManagementPage: ';

export class AuthorizedAppManagementParam {
  public presenter: CmShowAppCredPresenter;

  constructor(presenter: CmShowAppCredPresenter) {
    this.presenter = presenter;
  }
}

@Component
export struct DialogComponent {
  @Link uidItem: CmShowAppCredPresenter;
  private appName: string = '';
  private appImage: string = '';
  private indexNum: number = 0;

  onChanged?: () => void;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.appImage)
          .width($r('app.float.credentials_app_image_wh'))
          .height($r('app.float.credentials_app_image_hg'))

        Text(this.appName)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
          .margin({ left: $r('app.float.credentials_app_name_margin') })
      }
      .alignItems(VerticalAlign.Center)

      Toggle({ type: ToggleType.Switch, isOn: true })
        .width($r('app.float.credentials_app_Toggle_wh'))
        .height($r('app.float.credentials_app_Toggle_hg'))
        .selectedColor($r('app.color.credentials_app_Toggle_selectColor'))
        .onChange((isOn: boolean) => {
          this.uidItem.appInfoList[this.indexNum].status = isOn;
          if (!isOn) {
            this.onChanged?.();
          }
        })
        .margin({ right: $r('app.float.wh_value_16') })

    }.height($r('app.float.wh_value_72'))
  }
}

@Component
export struct AuthorizedAppManagementPage {
  private stack?: NavPathStack;

  @State presenter: CmShowAppCredPresenter = CmShowAppCredPresenter.getInstance();
  @Prop sheetParam: SheetParam;
  @State private headRectHeight: number = 64;
  @State private headRectHeightReal: number = 0;
  private scroller: Scroller = new Scroller();
  @State private scrollerHeight: number = 0;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          HeadComponent({ headName: $r('app.string.managerAuthApp'), isStartBySheet: true, onBackClicked: () => {
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
          Scroll(this.scroller) {
            List() {
              ForEach(this.presenter.appInfoList, (item: AppAuthorVo, index) => {
                ListItem() {
                  DialogComponent({ appImage: item.appImage, appName: item.appName,
                    indexNum: index, uidItem: $presenter,
                    onChanged: async () => {
                      await this.presenter.removeGrantedAppList(this.presenter.credInfo.keyUri);
                      this.presenter.getAuthorizedAppList(this.presenter.credInfo.keyUri);
                    } })
                }
              })
            }
            .scrollBar(BarState.Off)
            .divider({
              strokeWidth: $r('app.float.Evidence_strokeWidth'),
              color: $r('sys.color.ohos_id_color_list_separator'),
              startMargin: 64
            })
          }
          .align(Alignment.Top)
          .edgeEffect(EdgeEffect.Spring)
          .constraintSize({
            minHeight: this.getScrollMinHeight()
          })
          .scrollBar(BarState.Off)
          .padding({
            left: $r('app.float.wh_value_24'),
            bottom: $r('app.float.wh_value_24')
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
    }
    .hideTitleBar(true)
    .width(WidthPercent.WH_100_100)
    .height(this.sheetParam?.lastSheetPage === NavEntryKey.AUTHORIZED_APP_ENTRY ?
      WidthPercent.WH_AUTO : this.sheetParam?.sheetMinHeight)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((ctx: NavDestinationContext) => {
      this.stack = ctx.pathStack;
      try {
        this.presenter = (ctx.pathInfo.param as AuthorizedAppManagementParam).presenter;
      } catch (err) {
        let error = err as BusinessError;
        console.error(TAG + 'Get presenter failed: ' + error?.code + ', message: ' + error?.message);
      }
    })
  }

  getScrollMinHeight() {
    if (this.sheetParam === undefined || this.headRectHeightReal === 0 ||
      this.sheetParam.sheetMinHeight < this.headRectHeightReal) {
      return 0;
    }
    return this.sheetParam.sheetMinHeight - this.headRectHeightReal;
  }
}