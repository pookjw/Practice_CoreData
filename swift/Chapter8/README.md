- 큰 사진 (데이터)를 담고 있을 경우 자원 낭비가 심하다. thumbnail 같은 걸로 관리하고 필요할 때만 큰 사진을 불러오자.

- `NSFetchRequest`에서 `fetchBatchSize`를 설정하면 성능이 좋아진다.

- Swift 기본 함수를 쓴다는건 데이터를 모두 불러 온다는 뜻이다. 따라서 이런 사용은 피하고 `NSExpressionDescription`, `NSExpression`, `NSPredicate`를 쓰고, 단순 데이터의 개수를 알고 싶으면 굳이 `(fetch:)`를 하지 말고 `(count:)`를 활용하자.

- 이미 불러온 데이터에서 relationship을 통해 다른 데이터를 접근할 수 있으면 그걸 활용하자.
