/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.hardware.contexthub;

import android.hardware.contexthub.ContextHubInfo;
import android.hardware.contexthub.ContextHubMessage;
import android.hardware.contexthub.IContextHubCallback;
import android.hardware.contexthub.NanoappBinary;
import android.hardware.contexthub.Setting;

@VintfStability
interface IContextHub {
    /**
     * Enumerates all available Context Hubs.
     *
     * @return A list of ContextHubInfo describing all Context Hubs.
     */
    List<ContextHubInfo> getContextHubs();

    /**
     * Loads a nanoapp, and invokes the nanoapp's initialization "start()" entrypoint.
     *
     * The return value of this method only indicates that the request has been accepted.
     * If true is returned, the Context Hub must handle an asynchronous result using the
     * the handleTransactionResult() callback.
     *
     * Depending on the implementation, nanoapp loaded via this API may or may
     * not persist across reboots of the hub. If they do persist, the
     * implementation must initially place nanoapp in the disabled state upon a
     * reboot, and not start them until a call is made to enableNanoapp(). In
     * this case, the app must also be unloaded upon a factory reset of the
     * device.
     *
     * Loading a nanoapp must not take more than 30 seconds.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param appBinary The nanoapp binary with header
     * @param transactionId The transaction ID associated with this request
     *
     * @return The return code
     */
    boolean loadNanoapp(in int contextHubId, in NanoappBinary appBinary, in int transactionId);

    /**
     * Invokes the nanoapp's deinitialization "end()" entrypoint, and unloads the nanoapp.
     *
     * The return value of this method only indicates that the request has been accepted.
     * If true is returned, the Context Hub must handle an asynchronous result using the
     * the handleTransactionResult() callback.
     *
     * Unloading a nanoapp must not take more than 5 seconds.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param appId The unique ID of the nanoapp
     * @param transactionId The transaction ID associated with this request
     *
     * @return The return code
     */
    boolean unloadNanoapp(in int contextHubId, in long appId, in int transactionId);

    /**
     * Disables a nanoapp by invoking the nanoapp's "end()" entrypoint, but does not unload the
     * nanoapp.
     *
     * The return value of this method only indicates that the request has been accepted.
     * If true is returned, the Context Hub must handle an asynchronous result using the
     * the handleTransactionResult() callback.
     *
     * Disabling a nanoapp must not take more than 5 seconds.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param appId The unique ID of the nanoapp
     * @param transactionId The transaction ID associated with this request
     *
     * @return The return code
     */
    boolean disableNanoapp(in int contextHubId, in long appId, in int transactionId);

    /**
     * Enables a nanoapp by invoking the nanoapp's initialization "start()" entrypoint.
     *
     * The return value of this method only indicates that the request has been accepted.
     * If true is returned, the Context Hub must handle an asynchronous result using the
     * the handleTransactionResult() callback.
     *
     * Enabling a nanoapp must not take more than 5 seconds.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param appId appIdentifier returned by the HAL
     * @param message   message to be sent
     *
     * @return true on success
     */
    boolean enableNanoapp(in int contextHubId, in long appId, in int transactionId);

    /**
     * Notification sent by the framework to indicate that the user has changed a setting.
     *
     * @param setting User setting that has been modified
     * @param enabled true if the setting has been enabled, false otherwise
     */
    void onSettingChanged(in Setting setting, in boolean enabled);

    /**
     * Queries for a list of loaded nanoapps on a Context Hub.
     *
     * If this method succeeds, the result of the query must be delivered through the
     * handleNanoappInfo() callback.
     *
     * @param contextHubId The identifier of the Context Hub
     *
     * @return true on success
     */
    boolean queryNanoapps(in int contextHubId);

    /**
     * Register a callback for the HAL implementation to send asynchronous messages to the service
     * from a Context hub. There can only be one callback registered for a single Context Hub ID.
     *
     * A call to this function when a callback has already been registered must override the
     * previous registration.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param callback an implementation of the IContextHubCallbacks
     *
     * @return true on success
     *
     */
    boolean registerCallback(in int contextHubId, in IContextHubCallback cb);

    /**
     * Sends a message targeted to a nanoapp to the Context Hub.
     *
     * @param contextHubId The identifier of the Context Hub
     * @param message The message to be sent
     *
     * @return true on success
     */
    boolean sendMessageToHub(in int contextHubId, in ContextHubMessage message);
}
