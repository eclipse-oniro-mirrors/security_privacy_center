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
import ComponentConfig from './ComponentConfig';
import router from '@ohos.router';
import Constants from '../constants/ComConstant';
import { GlobalContext } from '../utils/GlobalContext';

/**
 * head custom component
 */
@Component
export default struct HeadComponent {
  @State isTouch: boolean = false;
  private isActive: boolean = true;
  private icBackIsVisibility: boolean = true;
  private headName: string | Resource = '';

  /**
   * 外部宿主拉起时，点击返回向拉起方发送 action: 'pop'
   */
  private onBackInSettings(): void {
    const intent: Record<string, Object> = { 'action': 'pop' };
    try {
      GlobalContext.getContext().getSession()?.sendData(intent);
    } catch (e) {
      console.error('HeadComponent', `onBackInSettings catch err. code:${e?.code} message:${e?.message}`);
    }
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.ic_back'))
          .fillColor($r('sys.color.ohos_id_color_primary'))
          .objectFit(ImageFit.Contain)
          .height(Constants.TITLE_BAR_IMAGE_HEIGHT)
          .width(Constants.TITLE_BAR_IMAGE_WIDTH)
          .draggable(false)
      }
      .width(Constants.CLICK_SHADOW_LENGTH)
      .height(Constants.CLICK_SHADOW_LENGTH)
      .borderRadius(Constants.CLICK_SHADOW_LENGTH/2)
      .flexShrink(0)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.isTouch ? $r('sys.color.ohos_id_color_click_effect') : "#d9e2e2e2")
      .hoverEffect(HoverEffect.Highlight)
      .onClick(() => {
        // 外部拉起时栈长为 1，发送 pop 给宿主；否则正常返回
        const length = router.getLength();
        Number(length) === 1 ? this.onBackInSettings() : router.back();
      })
      .onTouch((event?: TouchEvent | undefined) => {
        if (event?.type === TouchType.Down) {
          this.isTouch = true;
        }
        if (event?.type === TouchType.Up) {
          this.isTouch = false;
        }
      });

      Text(this.headName)
        .align(Alignment.Start)
        .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
        .maxLines(Constants.MAXIMUM_HEADER_LINES)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxFontSize( $r('sys.float.ohos_id_text_size_headline8'))
        .minFontSize(14)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .flexGrow(Constants.FLEX_GROW)
        .fontWeight(FontWeight.Medium)
        .margin({ left:  4 })
    }
    .width(ComponentConfig.WH_100_100)
    .height($r('app.float.wh_value_56'))
    .alignItems(VerticalAlign.Center)
    .align(Alignment.Start)
  }
}