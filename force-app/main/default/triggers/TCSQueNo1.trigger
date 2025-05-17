/* ───────────────────────────────────────────────────────────────────────
   Trigger: TCSQueNo1
   Fires after insert, update, delete on Case
──────────────────────────────────────────────────────────────────────── */
trigger TCSQueNo1 on Case (after insert, after update, after delete) {
    // Delegate all logic to handler
    if (Trigger.isAfter) {
        TCSQueNo1Handler.handle(
            Trigger.isDelete ? null : Trigger.new,
            Trigger.isDelete ? Trigger.oldMap : null,
            Trigger.isDelete
        );
    }
}
