package im.beavertalk.beavertalk

import android.content.Context
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.ViewConfiguration
import android.view.ViewGroup
import android.view.animation.Animation
import android.widget.ImageView
import kotlin.math.hypot

/**
 * 끌어서 발동시키는 수신 화면 버튼(수락/거절).
 *
 * ## 왜 `ImageView` 를 상속하는가
 *
 * 수신 화면은 Flutter 가 아니라 `flutter_callkit_incoming` 플러그인의 네이티브
 * [com.hiennv.flutter_callkit_incoming.CallkitIncomingActivity] 다. 그 액티비티는
 * 레이아웃을 `findViewById(R.id.ivAcceptCall)` 로 찾아 **`ImageView` 필드에 담고**
 * `setOnClickListener` 를 건다(`lateinit var ivAcceptCall: ImageView`).
 *
 * 우리는 플러그인을 포크(vendoring)하지 않고 **리소스 오버레이**로 레이아웃만 바꾼다
 * (앱 모듈의 `res/layout/activity_callkit_incoming.xml` 이 라이브러리의 같은 이름
 * 레이아웃을 이긴다). 그래서 이 뷰는 반드시 `ImageView` 하위여야 하고 id 도 그대로여야
 * 한다 — 아니면 `findViewById` 가 ClassCastException 을 낸다.
 *
 * 발동은 [performClick] 으로 한다. 액티비티가 건 클릭 리스너가 그대로 불리므로,
 * 액티비티 입장에서는 **평범한 ImageView 를 탭한 것과 구별되지 않는다.** 수락/거절
 * 처리(Telecom, 이벤트 전달, 화면 종료)는 한 줄도 건드리지 않는다.
 *
 * ## 조작감 — 아이콘은 움직이지 않는다
 *
 * 끌어도 **아이콘은 제자리에 고정**하고, 대신 뒤의 [CallWaveView] 파형이 진행도에 따라
 * 커진다. 안드로이드 기본 전화가 그렇다. 아이콘이 손가락을 따라다니면 "버튼을 옮기는"
 * 느낌이 나서 전화받기와 어울리지 않는다.
 *
 * - 끌수록 파형이 커지고, [triggerDistancePx] 를 넘으면 한 번 터지며 발동한다.
 * - 못 넘고 놓으면 파형이 대기 상태로 돌아간다.
 * - **탭도 그대로 동작한다.** 잠금 해제 상태에서는 이 액티비티 대신 헤드업 알림이
 *   뜨지만 그 알림을 탭하면 같은 액티비티가 열린다(`setContentIntent`). 그 경로의
 *   기존 탭 동작을 깨뜨리지 않는다.
 *
 * 방향을 제한하지 않는 이유: 잠금화면에서 한 손으로, 화면을 제대로 보지 않고 조작하는
 * 경우가 많다. 어느 쪽으로 끌어도 거리만 채우면 받아준다.
 */
class SwipeToActionView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
) : ImageView(context, attrs, defStyleAttr) {

    /** 발동 거리. 오조작 방지와 한 손 조작 편의 사이의 절충. */
    private val triggerDistancePx = TRIGGER_DISTANCE_DP * resources.displayMetrics.density

    /** 이 거리를 넘어야 "끄는 중"으로 본다(그 전까지는 탭일 수 있다). */
    private val slopPx = ViewConfiguration.get(context).scaledTouchSlop.toFloat()

    private var startRawX = 0f
    private var startRawY = 0f
    private var dragging = false

    /** 이미 발동했는가. 이후 MOVE 이벤트로 두 번 발동하는 것을 막는다. */
    private var triggered = false

    /** 뒤에서 파형을 그리는 형제 뷰(같은 부모 안에서 찾는다). */
    private var wave: CallWaveView? = null

    /**
     * 액티비티가 거는 흔들림 애니메이션을 무력화한다.
     *
     * `CallkitIncomingActivity.animateAcceptCall()` 이 `ivAcceptCall.animation =
     * shake_anim` 을 설정한다(= 이 메서드 호출). 아이콘을 고정해 두는 것이 이 화면의
     * 핵심인데 흔들림이 남아 있으면 그게 무너진다. 유도는 파형이 대신한다.
     */
    override fun setAnimation(animation: Animation?) {
        // no-op
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        wave = findSiblingWave()
    }

    override fun onDetachedFromWindow() {
        wave = null
        super.onDetachedFromWindow()
    }

    /** 같은 부모 안의 [CallWaveView] 를 찾는다(레이아웃에서 버튼 바로 뒤에 둔다). */
    private fun findSiblingWave(): CallWaveView? {
        val group = parent as? ViewGroup ?: return null
        for (i in 0 until group.childCount) {
            val child = group.getChildAt(i)
            if (child is CallWaveView) return child
        }
        return null
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                startRawX = event.rawX
                startRawY = event.rawY
                dragging = false
                triggered = false
                // 조상(LinearLayout 등)이 제스처를 가로채 끌기가 끊기지 않게 한다.
                parent?.requestDisallowInterceptTouchEvent(true)
                return true
            }

            MotionEvent.ACTION_MOVE -> {
                if (triggered) return true
                val distance = hypot(event.rawX - startRawX, event.rawY - startRawY)
                if (!dragging && distance > slopPx) dragging = true
                if (dragging) {
                    wave?.progress = distance / triggerDistancePx
                    if (distance >= triggerDistancePx) {
                        triggered = true
                        wave?.burst()
                        // 액티비티가 건 클릭 리스너 = 수락/거절 처리.
                        performClick()
                    }
                }
                return true
            }

            MotionEvent.ACTION_UP -> {
                if (!triggered) {
                    // 끌지 않았으면 탭으로 해석한다(기존 동작 보존).
                    if (dragging) wave?.reset() else performClick()
                }
                dragging = false
                return true
            }

            MotionEvent.ACTION_CANCEL -> {
                if (!triggered) wave?.reset()
                dragging = false
                return true
            }
        }
        return super.onTouchEvent(event)
    }

    private companion object {
        const val TRIGGER_DISTANCE_DP = 96f
    }
}
