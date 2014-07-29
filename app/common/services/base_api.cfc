component {
    public struct function GetNewResponse() {
        local.response = {
            success = true,
            errors = [],
            data = ""
        };

        return local.response;
    }
}
