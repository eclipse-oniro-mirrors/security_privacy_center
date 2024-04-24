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

import CmInstallPresenterTest from './presenter/CMInstallPresenter.test'
import CMFaPresenterTest from './presenter/CMFaPresenter.test';
import CheckUserAuthModelTest from './model/CheckUserAuthModel.test';
import PreventScreenshotsModelTest from './model/PreventScreenshotsModel.test';
import CertManagerModelTest from './model/CertManagerModel.test';
import GlobalContextTest from './common/GlobalContext.test';
import CmAppCredAuthPresenterTest from './presenter/CmAppCredAuthPresenter.test';
import BundleModelTest from './model/BundleModel.test';
import CertManagerModelTestPart2 from './model/CertManagerModelPart2.test';
import FileIoModelTest from './model/FileIoModel.test';
import CmShowSysCredPresenterTest from './presenter/CmShowSysCredPresenter.test';
import CmShowAppCredPresenterTest from './presenter/CmShowAppCredPresenter.test';
import CmShowSysCaPresenterTest from './presenter/CmShowSysCaPresenter.test';
import CmShowUserCaPresenterTest from './presenter/CmShowUserCaPresenter.test';

export default function testsuite() {
  CmInstallPresenterTest();
  CMFaPresenterTest();
  CheckUserAuthModelTest();
  PreventScreenshotsModelTest();
  CertManagerModelTest();
  GlobalContextTest();
  CmAppCredAuthPresenterTest();
  BundleModelTest();
  CertManagerModelTestPart2();
  FileIoModelTest();
  CmShowSysCredPresenterTest();
  CmShowAppCredPresenterTest();
  CmShowSysCaPresenterTest();
  CmShowUserCaPresenterTest();
}