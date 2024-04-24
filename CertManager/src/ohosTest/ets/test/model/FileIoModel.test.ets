/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import FileIoModel from '../../../../main/ets/model/FileIoModel';

export default function FileIoModelTest() {
  describe('FileIoModelTest', () => {

    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })

    it("getMediaFileDataTest001", 0, (done: Function) => {
      let mediaUri:string = 'file://docs/storage/Users/currentUser/Documents/temp.p12';
      FileIoModel.getMediaFileData(mediaUri,(ret: Uint8Array) => {
        expect(ret === undefined).assertTrue();
        done();
      })
    })

    it("getMediaFileDataTest002", 0, (done: Function) => {
      let mediaUri:string = '';
      FileIoModel.getMediaFileData(mediaUri,(ret: Uint8Array) => {
        expect(ret === undefined).assertTrue();
        done();
      })
    })

    it("getMediaFileSuffix001", 0, (done: Function) => {
      let mediaUri:string = 'file://docs/storage/Users/currentUser/Documents/temp.p12';
      FileIoModel.getMediaFileSuffix(mediaUri,(ret: Uint8Array) => {
        expect(ret === undefined).assertFalse();
        done();
      })
    })

    it("getMediaFileSuffix002", 0, (done: Function) => {
      let mediaUri:string = '';
      FileIoModel.getMediaFileSuffix(mediaUri,(ret: Uint8Array) => {
        expect(ret === undefined).assertFalse();
        done();
      })
    })
  })
}