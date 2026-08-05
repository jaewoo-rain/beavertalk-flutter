package im.beavertalk.beavertalk

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View
import android.view.animation.LinearInterpolator

/**
 * 수신 화면 버튼 뒤에서 밖으로 퍼지는 파형.
 *
 * [SwipeToActionView] 와 짝을 이룬다. **아이콘은 제자리에 고정**되고, 사용자가 끄는
 * 진행도에 따라 이 파형만 커진다 — 안드로이드 기본 전화의 조작감을 따른 것이다.
 * (아이콘이 손가락을 따라다니면 "버튼을 옮기는" 느낌이 나서 전화받기와 어울리지 않는다.)
 *
 * 구성:
 * - **정지 원**: 버튼이 돌아올 자리를 표시한다.
 * - **퍼지는 링 [RING_COUNT]개**: 위상을 나눠 가져 끊김 없이 이어진다.
 * - **진폭**: 대기 중엔 [IDLE_AMPLITUDE] 로 은은하게, 끄는 동안 [progress] 에 비례해
 *   커진다. 임계치에 닿으면 [burst] 로 한 번 크게 터진다.
 *
 * 위상 애니메이터는 항상 돌고 진폭만 바뀐다. 그래야 끌기 시작/끝에서 파형이 튀지 않고
 * 자연스럽게 이어진다.
 *
 * 부모들의 `clipChildren="false"` 에 기대어 자기 경계 밖까지 그린다.
 */
class CallWaveView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
) : View(context, attrs, defStyleAttr) {

    private var waveColor: Int = Color.WHITE

    private val ringPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeWidth = 2f * resources.displayMetrics.density
    }
    private val discPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
    }

    /** 0..1 반복. 링이 밖으로 이동하는 위상. */
    private var phase = 0f

    /** 현재 진폭(대기/끌기/터짐을 통틀어 파형의 크기). */
    private var amplitude = IDLE_AMPLITUDE

    /** 끌기 진행도 0..1. [SwipeToActionView] 가 갱신한다. */
    var progress: Float = 0f
        set(value) {
            val clamped = value.coerceIn(0f, 1f)
            if (field == clamped) return
            field = clamped
            if (burstAnimator == null) {
                amplitude = IDLE_AMPLITUDE + (1f - IDLE_AMPLITUDE) * clamped
                invalidate()
            }
        }

    private var phaseAnimator: ValueAnimator? = null
    private var burstAnimator: ValueAnimator? = null

    init {
        if (attrs != null) {
            val a = context.obtainStyledAttributes(attrs, R.styleable.CallWaveView)
            waveColor = a.getColor(R.styleable.CallWaveView_waveColor, Color.WHITE)
            a.recycle()
        }
        ringPaint.color = waveColor
        discPaint.color = waveColor
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        phaseAnimator = ValueAnimator.ofFloat(0f, 1f).apply {
            duration = PHASE_DURATION_MS
            repeatCount = ValueAnimator.INFINITE
            interpolator = LinearInterpolator()
            addUpdateListener {
                phase = it.animatedValue as Float
                invalidate()
            }
            start()
        }
    }

    override fun onDetachedFromWindow() {
        phaseAnimator?.cancel()
        phaseAnimator = null
        burstAnimator?.cancel()
        burstAnimator = null
        super.onDetachedFromWindow()
    }

    /** 임계치 도달 — 파형을 한 번 크게 터뜨린다. */
    fun burst() {
        burstAnimator?.cancel()
        burstAnimator = ValueAnimator.ofFloat(amplitude, BURST_AMPLITUDE).apply {
            duration = BURST_DURATION_MS
            addUpdateListener {
                amplitude = it.animatedValue as Float
                invalidate()
            }
            start()
        }
    }

    /** 끌기 취소 — 대기 상태로 되돌린다. */
    fun reset() {
        burstAnimator?.cancel()
        burstAnimator = null
        progress = 0f
        amplitude = IDLE_AMPLITUDE
        invalidate()
    }

    override fun onDraw(canvas: Canvas) {
        val cx = width / 2f
        val cy = height / 2f
        val half = minOf(width, height) / 2f
        if (half <= 0f) return

        val restRadius = half * REST_RADIUS_RATIO

        // 버튼이 돌아올 자리.
        discPaint.alpha = REST_DISC_ALPHA
        canvas.drawCircle(cx, cy, restRadius, discPaint)

        // 밖으로 퍼지는 링들. 위상을 나눠 가져 끊김이 없다.
        val spread = half * MAX_SPREAD_RATIO * amplitude
        for (i in 0 until RING_COUNT) {
            val local = (phase + i.toFloat() / RING_COUNT) % 1f
            val radius = restRadius + spread * local
            // 멀어질수록 옅어진다.
            val alpha = ((1f - local) * RING_MAX_ALPHA * amplitude).toInt().coerceIn(0, 255)
            if (alpha == 0) continue
            ringPaint.alpha = alpha
            canvas.drawCircle(cx, cy, radius, ringPaint)
        }
    }

    private companion object {
        const val RING_COUNT = 3
        const val PHASE_DURATION_MS = 1500L
        const val BURST_DURATION_MS = 260L

        /** 대기 중 진폭. 0 이면 화면이 죽어 보이고, 크면 끌기 변화가 안 읽힌다. */
        const val IDLE_AMPLITUDE = 0.34f
        const val BURST_AMPLITUDE = 1.6f

        /** 정지 원 반지름 = 뷰 반지름 × 이 값. 버튼(60dp)보다 살짝 크게. */
        const val REST_RADIUS_RATIO = 0.44f

        /** 링이 퍼져 나가는 최대 거리(진폭 1 기준). */
        const val MAX_SPREAD_RATIO = 1.05f

        const val REST_DISC_ALPHA = 38
        const val RING_MAX_ALPHA = 210f
    }
}
