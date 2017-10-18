// Any very generic helpr functions go in here. Might not be any.


export const getOrdinal = function(n) {
    var s=["th","st","nd","rd"],
    v=n%100;
    return n+(s[(v-20)%10]||s[v]||s[0]);
 }
